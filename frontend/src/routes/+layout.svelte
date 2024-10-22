<script>
	import { navigating } from '$app/stores';
  import { onDestroy } from 'svelte';
	import SkeletonLoader from '../lib/SkeletonLoader.svelte';
	import Nav from './Nav.svelte';
	import PreloadingIndicator from './PreloadingIndicator.svelte';
	import { isLoading } from './store';
	let loading = false;
	const unsubscribe = isLoading.subscribe(value => {
		loading = value;
	});

	onDestroy(() => {
		unsubscribe();
	});
</script>


{#if $navigating}
	<PreloadingIndicator />
{/if}

<Nav />

<SkeletonLoader {loading}/>

<main>
	<slot />
</main>
