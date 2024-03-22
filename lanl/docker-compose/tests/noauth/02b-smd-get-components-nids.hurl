#
# Get Components we added corresponding to the MAC addresses
#

GET http://smd-noauth:27779/hsm/v2/State/Components/x0c1s1b0

# Response should be:
#
# {
#	 "ID": "x0c1s1b0",
#	 "Type": "Node",
#	 "Enabled": false
# }
HTTP 200
Content-Type: application/json
[Asserts]
jsonpath "$.ID" == "x0c1s1b0"
jsonpath "$.Type" == "Node"
jsonpath "$.Enabled" == true

GET http://smd-noauth:27779/hsm/v2/State/Components/x0c1s3b0
# Response should be:
#
# {
#	 "ID": "x0c1s3b0",
#	 "Type": "Node",
#	 "Enabled": false
# }
HTTP 200
Content-Type: application/json
[Asserts]
jsonpath "$.ID" == "x0c1s3b0"
jsonpath "$.Type" == "Node"
jsonpath "$.Enabled" == true
