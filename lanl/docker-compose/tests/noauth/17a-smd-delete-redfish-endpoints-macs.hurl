# Delete RedfishEndpoint for first XName.
DELETE http://smd-noauth:27779/hsm/v2/Inventory/RedfishEndpoints/x0c0s1b0

HTTP 200

# Ensure RedfishEndpoint was deleted for first XName.
GET http://smd-noauth:27779/hsm/v2/Inventory/RedfishEndpoints/x0c0s1b0

HTTP 404

# Delete RedfishEndpoint for third XName.
DELETE http://smd-noauth:27779/hsm/v2/Inventory/RedfishEndpoints/x0c0s3b0

HTTP 200

# Ensure RedfishEndpoint was deleted for third XName.
GET http://smd-noauth:27779/hsm/v2/Inventory/RedfishEndpoints/x0c0s3b0

HTTP 404
