package main

import (
	"context"
	"fmt"
	"net/http"
	"os"
	"strconv"

	"github.com/go-redis/redis/v8"
)

var ctx = context.Background()
var redisAddress = "localhost:6379"

func main() {
	if len(os.Args) == 2 {
		redisAddress = os.Args[1]
	}
	fmt.Println("connecting to:" + redisAddress)
	http.HandleFunc("/", root)
	http.HandleFunc("/favicon.ico", func(w http.ResponseWriter, r *http.Request) {})
	http.HandleFunc("/health", healthcheck)
	http.ListenAndServe(":8080", nil)
}

func root(w http.ResponseWriter, r *http.Request) {
	var visitorCount = redisGetValue("visitor")
	fmt.Fprintf(w, "Visitor count: "+visitorCount)
	redisSetValue("visitor", visitorCount)
}

func healthcheck(w http.ResponseWriter, r *http.Request) {
	fmt.Println("healthcheck")
	fmt.Fprintf(w, "ok")
}

func redisPing() {
	rdb := redis.NewClient(&redis.Options{
		Addr: redisAddress,
	})

	pong, err := rdb.Ping(ctx).Result()
	fmt.Println(pong, err)
	// Output: PONG <nil>
}

func redisGetValue(key string) string {
	rdb := redis.NewClient(&redis.Options{
		Addr:     redisAddress,
		Password: "", // no password set
		DB:       0,  // use default DB
	})

	val, err := rdb.Get(ctx, key).Result()
	if err == redis.Nil {
		val = "1"
	}
	fmt.Println(key, val)
	rdb.Close()
	return val
}

func redisSetValue(key string, value string) {
	rdb := redis.NewClient(&redis.Options{
		Addr:     redisAddress,
		Password: "", // no password set
		DB:       0,  // use default DB
	})

	newValue, err := strconv.Atoi(value)
	sNewValue := strconv.Itoa(newValue + 1)

	err = rdb.Set(ctx, key, sNewValue, 0).Err()

	if err != nil {
		rdb.Close()
		panic(err)
	}
	rdb.Close()
}
