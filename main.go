package main

import (
	"encoding/json"
	"net/http"
	"time"
)

type TimeResponse struct {
	CurrentTime string `json:"current_time"`
}

func TimeHandler(w http.ResponseWriter, r *http.Request) {
	currentTime := time.Now().Format(time.RFC3339)
	response := TimeResponse{CurrentTime: currentTime}
	json.NewEncoder(w).Encode(response)
}

func main() {
	http.HandleFunc("/time", TimeHandler)
	http.ListenAndServe(":8080", nil)
}
