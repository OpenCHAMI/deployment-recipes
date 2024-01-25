# Delete Component for first XName.
DELETE http://smd:27779/hsm/v2/State/Components/x0c0s1b0

HTTP 200

# Delete Component for third XName.
DELETE http://smd:27779/hsm/v2/State/Components/x0c0s3b0

HTTP 200

# Get Components (should be empty).
GET http://smd:27779/hsm/v2/State/Components

HTTP 200
[Asserts]
jsonpath "$.Components" count == 0
