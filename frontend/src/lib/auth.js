import { PUBLIC_COGNITO_APP_CLIENT_ID, PUBLIC_COGNITO_URL, PUBLIC_REDIRECT_URL } from '$env/static/public';

const cognitoAppClientId = PUBLIC_COGNITO_APP_CLIENT_ID;
const cognitoUrl = PUBLIC_COGNITO_URL;
const redirectUrl = PUBLIC_REDIRECT_URL;

export function getSignInUrl() {

	// The login api endpoint with the required parameters.
	const loginUrl = new URL("/login", cognitoUrl);
	loginUrl.searchParams.set("response_type", "code");
	loginUrl.searchParams.set("client_id", cognitoAppClientId);
	loginUrl.searchParams.set("redirect_uri", redirectUrl);
	loginUrl.searchParams.set("scope", "email openid");

	return loginUrl.toString();
}

export function getRegisterUrl() {

	// The login api endpoint with the required parameters.
	const loginUrl = new URL("/signup", cognitoUrl);
	loginUrl.searchParams.set("response_type", "code");
	loginUrl.searchParams.set("client_id", cognitoAppClientId);
	loginUrl.searchParams.set("redirect_uri", redirectUrl);
	loginUrl.searchParams.set("scope", "email openid");

	return loginUrl.toString();
}

export function getSignOutUrl(){
	const logoutUrl = new URL("/logout", cognitoUrl);
	logoutUrl.searchParams.set("response_type", "code");
	logoutUrl.searchParams.set("client_id", cognitoAppClientId);
	logoutUrl.searchParams.set("redirect_uri", redirectUrl);
	logoutUrl.searchParams.set("logout_uri", redirectUrl);
	logoutUrl.searchParams.set("scope", "email openid");
	
	return logoutUrl.toString();
}


