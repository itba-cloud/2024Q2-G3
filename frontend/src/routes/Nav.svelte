<script>
	import { page } from '$app/stores';
	import { token } from  '../routes/store';
	import { fetchAuthSession, signOut } from 'aws-amplify/auth';
	import { onMount } from 'svelte';

	onMount(async () => {
		const session = await fetchAuthSession();
		token.set(session?.tokens?.idToken);
		console.log("Cambiando session en nav")
		token.subscribe(value => console.log("cambio:" + value));
	});

	const logout = () => {
		signOut();
		token.set(undefined);
	}
	
	$: isAuthenticated = $token != undefined;

</script>

<nav class="navbar navbar-light">
	<div class="container">
		<a class="navbar-brand" href="/">Soul pupils</a>
		<ul class="nav navbar-nav pull-xs-right">
			<li class="nav-item">
				<a class="nav-link" class:active={$page.url.pathname === '/'} href="/">Home</a>
			</li>

			{#if isAuthenticated}
				<li class="nav-item">
					<a href="/" class="nav-link" class:active={$page.url.pathname === '/logout'} on:click={logout}>
						Logout
					</a>
				</li>
				<!-- <li class="nav-item">
					<a href="/editor" class="nav-link" class:active={$page.url.pathname === '/editor'}>
						<i class="ion-compose" />&nbsp;New Post
					</a>
				</li>

				<li class="nav-item">
					<a href="/settings" class="nav-link" class:active={$page.url.pathname === '/settings'}>
						<i class="ion-gear-a" />&nbsp;Settings
					</a>
				</li>

				<li class="nav-item">
					<a href="/profile/@{$page.data.user.username}" class="nav-link">
						{$page.data.user.username}
					</a>
				</li> -->
				
				
				
			{:else}
				<li class="nav-item">
					<a href='/login' class="nav-link" class:active={$page.url.pathname === '/login'}>
						Sign in
					</a>
				</li>

				<li class="nav-item">
					<a href='/register' class="nav-link" class:active={$page.url.pathname === '/register'}>
						Sign up
					</a>
				</li>
				
			{/if}
		</ul>
	</div>
</nav>
