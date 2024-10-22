<script>
  import { onMount } from 'svelte';
  import { token, refreshToken } from '../store';
  import { PUBLIC_COGNITO_APP_CLIENT_ID, PUBLIC_COGNITO_URL, PUBLIC_REDIRECT_URL } from '$env/static/public';
  import { isLoading } from '../store';
  import { goto } from '$app/navigation';

  let code = '';
  let error = '';

  onMount(() => {
    const params = new URLSearchParams(window.location.search);
    code = params.get('code');
    error = params.get('error');

    if (code) {
      handleCognitoAuth({code: code});
      goto(window.history.state?.referrer || '/');
    } else if (error) {
      console.error('OAuth Error:', error);
    } else {
      goto('/');
    }
    
  });

  async function handleCognitoAuth(options) {
    isLoading.set(true);
    let response;
    try {
      const bodyObj = new URLSearchParams({
        grant_type: options.code ? 'authorization_code' : 'refresh_token',
        client_id: PUBLIC_COGNITO_APP_CLIENT_ID,
        redirect_uri: PUBLIC_REDIRECT_URL,
        code: options.code,
        refresh_token: options.refreshToken,
      });
      console.log(bodyObj.toString());

      const response = await fetch(new URL("oauth2/token/", PUBLIC_COGNITO_URL), {
          method: "POST",
          headers: {
              "Content-Type": "application/x-www-form-urlencoded",
          },
          body: bodyObj.toString(),
      });
      const {id_token, refresh_token} = await response.json();

      token.set(id_token);
      refreshToken.set(refresh_token);

      console.log("Token stored");
      // localStorage.setItem('token', token.id_token);
      // localStorage.setItem('refresh_token', token.refresh_token);
    } catch (error) {
      throw error;
    } finally {
      isLoading.set(false);
    }
  
}
    // }).then(response => response.json())
    //   .then(data => {
    //     console.log('OAuth Response:', data);
    //     localStorage.setItem('token', data.id_token);
    //     window.location.href = '/';
    //   })
    //   .catch(error => {
    //     console.error('OAuth Error:', error);
    //   });
</script>

<div>
</div>