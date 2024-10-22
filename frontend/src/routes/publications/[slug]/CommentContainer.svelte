<script>
	import CommentInput from './CommentInput.svelte';
	import Comment from './Comment.svelte';
	import {token} from '../../store';
	import { getRegisterUrl, getSignInUrl } from '../../../lib/auth';

	$: isAuthenticated = $token !== null;
	export let comments;
	// export let user;
</script>

<div class="col-xs-12 col-md-8 offset-md-2">
	{#if isAuthenticated}
		<CommentInput on:commentForm/>
	{:else}
		<p>
			<a href="{getSignInUrl()}">Sign in</a>
			or
			<a href="{getRegisterUrl()}">sign up</a>
			to add comments on this article.
		</p>
	{/if}
	{#each comments as comment (comment.comment_id)}
		<Comment {comment} />
	{/each}
	
</div>
