#!/bin/bash
bucket_name=$1
backend_url=$2
userpools_id=$3
client_id=$4
cognito_url=$5
region=$6
cd ./../frontend
echo PUBLIC_BASE_PATH=$backend_url > .env

cat <<EOL > ./src/aws-exports.js
const awsmobile = {
  aws_project_region: "$region",
  aws_cognito_region: "$region",
  aws_user_pools_id: "$userpools_id",
  aws_user_pools_web_client_id: "$client_id",
  oauth: {
    domain: "$cognito_url",
  },
  aws_cognito_username_attributes: ["EMAIL", "PREFERRED_USERNAME"],
  aws_cognito_social_providers: [],
  aws_cognito_signup_attributes: [],
  aws_cognito_mfa_configuration: "OFF",
  aws_cognito_mfa_types: [],
  aws_cognito_password_protection_settings: {
    passwordPolicyMinLength: 8,
    passwordPolicyCharacters: [
      "REQUIRES_LOWERCASE",
      "REQUIRES_UPPERCASE",
      "REQUIRES_NUMBERS",
      "REQUIRES_SYMBOLS",
    ],
  },
  aws_cognito_verification_mechanisms: ["EMAIL"],
};

export default awsmobile;
EOL


npm install
npm run build
aws s3 cp build s3://$1 --recursive