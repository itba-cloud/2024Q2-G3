<script>
	import { createEventDispatcher } from 'svelte';
	const dispatch = createEventDispatcher();

	const createComment = (e) => {
		e.preventDefault();
		const data = new FormData(e.target);
		
		dispatch('commentForm', {
			comment: {
				content: data.get('content')
			}
		});
		e.target.reset();

		setTimeout(() => {
			window.location.reload();
		}, 500);
	};
</script>

<form method="POST" action="?/createComment" class="card comment-form" on:submit={createComment}>
	<div class="card-block" style="padding: 20px;">
		<h3 class="card-title">Post a comment</h3>
		<textarea class="form-control" name="content" placeholder="Write a comment..." style="border: 1px solid #ccc; margin-top: 20px;" required></textarea>
	</div>

	<div class="card-footer">
		<button class="btn btn-sm btn-primary" type="submit">Post Comment</button>
	</div>
</form>
