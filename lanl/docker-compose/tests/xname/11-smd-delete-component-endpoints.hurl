## Delete ComponentEndpoint for first XName.
#DELETE http://smd:27779/hsm/v2/Inventory/ComponentEndpoints/x0c2s1b0
#
#HTTP 200
#
## Delete ComponentEndpoint for third XName.
#DELETE http://smd:27779/hsm/v2/Inventory/ComponentEndpoints/x0c2s3b0
#
#HTTP 200

# Get ComponentEndpoints (should be empty).
GET http://smd:27779/hsm/v2/Inventory/ComponentEndpoints

HTTP 200
[Asserts]
jsonpath "$.ComponentEndpoints" count == 0
