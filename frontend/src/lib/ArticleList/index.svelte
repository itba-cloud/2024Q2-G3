<script>
	import { page } from '$app/stores';
	import ArticlePreview from './ArticlePreview.svelte';

	export let publications;
</script>

{#if publications.length === 0}
	<div class="article-preview">No publications are here... yet.</div>
{:else}
	<div>
		{#each publications as publication (publication.publication_id)}
			<ArticlePreview {publication} user={$page.data.user} />
		{/each}
	</div>
{/if}
