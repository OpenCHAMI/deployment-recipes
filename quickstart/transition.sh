transition() {
	echo "${1}" | jq

	curl \
		-s \
		-H "Content-Type: application/json" \
		-X POST \
		-d "${1}" \
		localhost:28007/transitions | jq
}

print_operation_list() {
	echo "on"
	echo "off"
	echo "soft-restart"
	echo "hard-restart"
	echo "init"
	echo "force-off"
	echo "soft-off"
}

print_operation_list

# transition '[{"operation": "forceoff", "taskDeadlineMinutes": 12, "location": {"xname": "x1000c0s0b3", "deputyKey,omitempty": "asdf"}}]'
# transition '{"operation": "off", "taskDeadlineMinutes": 12, "location": [{"xname": "x1000c0s0b3", "deputyKey,omitempty": "asdf"}]}'
transition '{"operation": "off", "taskDeadlineMinutes": 12, "location": [{"xname": "x1000c0s0b3n0", "deputyKey,omitempty": "asdf"}]}'
