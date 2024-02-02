## Delete ComponentEndpoint for first XName.
#DELETE http://smd:27779/hsm/v2/Inventory/ComponentEndpoints/x0c0s1b0
#
#HTTP 200
#
## Delete ComponentEndpoint for third XName.
#DELETE http://smd:27779/hsm/v2/Inventory/ComponentEndpoints/x0c0s3b0
#
#HTTP 200

# Ensure ComponentEndpoint was deleted for first XName.
GET http://smd:27779/hsm/v2/Inventory/ComponentEndpoints/x0c0s1b0

HTTP 404

# Ensure ComponentEndpoint was deleted for second XName.
GET http://smd:27779/hsm/v2/Inventory/ComponentEndpoints/x0c0s2b0

HTTP 404

# Ensure ComponentEndpoint was deleted for third XName.
GET http://smd:27779/hsm/v2/Inventory/ComponentEndpoints/x0c0s3b0

HTTP 404
