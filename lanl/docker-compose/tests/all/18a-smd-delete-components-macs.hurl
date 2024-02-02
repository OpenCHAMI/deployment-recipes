# Delete Component for first XName.
DELETE http://smd:27779/hsm/v2/State/Components/x0c0s1b0

HTTP 200

# Ensure Component was deleted for first XName.
GET http://smd:27779/hsm/v2/State/Components/x0c0s1b0

HTTP 404

# Delete Component for third XName.
DELETE http://smd:27779/hsm/v2/State/Components/x0c0s3b0

HTTP 200

# Ensure Component was deleted for third XName.
GET http://smd:27779/hsm/v2/State/Components/x0c0s3b0

HTTP 404
