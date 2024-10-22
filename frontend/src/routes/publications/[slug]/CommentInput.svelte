<script>
	import { createEventDispatcher } from 'svelte';
	const dispatch = createEventDispatcher();

	const createComment = async (e) => {
		e.preventDefault();
		const data = new FormData(e.target);
		dispatch('commentForm', {
			comment: {
				content: data.get('content')
			} 
		});
		e.target.reset();
	};
</script>
		
<form method="POST" action="?/createComment" class="card comment-form" on:submit={createComment}>
	<div class="card-block" style="padding: 20px;">
		
		<h3 class="card-title">Post a comment</h3>

		<!-- <div>
			<label for="username">Username</label>
			<input type="text" id="username" name="username" class="form-control" required />
		</div>
		<div>
			<label for="email">Email</label>
			<input type="email" id="email" name="email" class="form-control" required />
		</div> -->
		<textarea class="form-control" name="content" placeholder="Write a comment..." style="border: 1px solid #ccc; margin-top: 20px;" required></textarea>
	</div>

	<div class="card-footer">
		<!-- <img src={user.image || placeholder} class="comment-author-img" alt={user.username} /> -->
		<button class="btn btn-sm btn-primary" type="submit">Post Comment</button>
	</div>
</form>
