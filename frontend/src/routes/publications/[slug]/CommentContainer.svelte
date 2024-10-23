<script>
	import CommentInput from './CommentInput.svelte';
	import Comment from './Comment.svelte';
	import { token } from '../../store';

	$: isAuthenticated = $token !== undefined;
	export let comments;
</script>

<div class="col-xs-12 col-md-8 offset-md-2">
	{#if isAuthenticated}
		<CommentInput on:commentForm/>
	{:else}
		<p>
			<a href="/login">Sign in</a>
			or
			<a href="/register">sign up</a>
			to add comments on this article.
		</p>
	{/if}
	{#each comments as comment (comment.comment_id)}
		<Comment {comment} />
	{/each}
	
</div>
