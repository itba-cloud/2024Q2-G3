<script>
	export let publication;
	export let user;


	function getFirstChars(content, count) {
		content = content.replace(/!\[.*\]\(.*\)/g, '');
		if (content.length <= count) return content;
		return content.slice(0, count) + '...';
	}

</script>

<div class="article-preview">
	<div class="article-meta">
		<!-- <a href="/profile/@{publication.author}">
			<img src={article.author.image} alt={article.author.username} /> -->
		<!-- </a> -->

		<div class="info" style="margin: 0;">
			<!-- <a class="author" href="/profile/@{publication.user}">{publication.author}</a> -->
			{publication.user.username}
			<span class="date">{new Date(publication.created_at).toDateString()}</span>
		</div>

		<!-- {#if user}
			<form
				method="POST"
				action="/article/{article.slug}?/toggleFavorite"
				use:enhance={({ form }) => {
					// optimistic UI
					if (article.favorited) {
						article.favorited = false;
						article.favoritesCount -= 1;
					} else {
						article.favorited = true;
						article.favoritesCount += 1;
					}

					const button = form.querySelector('button');
					button.disabled = true;

					return ({ result, update }) => {
						button.disabled = false;
						if (result.type === 'error') update();
					};
				}}
				class="pull-xs-right"
			>
				<input hidden type="checkbox" name="favorited" checked={article.favorited} />
				<button class="btn btn-sm {article.favorited ? 'btn-primary' : 'btn-outline-primary'}">
					<i class="ion-heart" />
					{article.favoritesCount}
				</button>
			</form>
		{/if} -->
	</div>

	<a href="/publications/{publication?.publication_id}" class="preview-link">
		<h1>{publication?.title}</h1>
		{getFirstChars(publication?.content, 20)}
		<!-- read more in a new line -->
		<br />
		<span>Read more...</span>
		<!-- <ul class="tag-list"> -->
			<!-- {#each article.tagList as tag}
				<li class="tag-default tag-pill tag-outline"><a href="/?tag={tag}">{tag}</a></li>
			{/each} -->
		<!-- </ul> -->
	</a>
</div>
