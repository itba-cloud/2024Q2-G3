<script>
  import CommentContainer from './CommentContainer.svelte';
  import Markdown from '@magidoc/plugin-svelte-marked';
  import { onMount } from 'svelte';
  import { page } from '$app/stores';
  import * as api from '$lib/api';
  import Toast from '../../Toast.svelte';
  import { toastStore } from '../../store';

  let data;
  let form;
  let publication = null;
  let comments = [];
  let currentPage = 1; 
  let totalPages = 1;  
  let loading = false; 

  $: p = +($page.url.searchParams.get('page') ?? '1');
  $: title = publication?.title || 'Loading';
  $: content = publication?.content || '';

  onMount(async () => {
    await fetchData();
  });

  async function fetchData() {
    const params = $page.params;
    const qPub = new URLSearchParams();
    qPub.set('publication_id', params.slug);

    const { publication: pub } = await api.get(`get_publications?${qPub}`);
    publication = pub;

    await loadComments();
  }

  async function loadComments() {
    if (loading || currentPage > totalPages) return;
    loading = true;

    const params = $page.params;
    const qCom = new URLSearchParams();
    qCom.set('publication_id', params.slug);
    qCom.set('page', currentPage);

    const { comments: com, total_pages } = await api.get(`get_comments?${qCom}`);

    console.log(com);
    comments = [...comments, ...com];

    totalPages = total_pages;
    currentPage += 1;

    loading = false;
  }

  const loadNewComment = async (e) => {
    const publicationId = $page.params.slug;
    const comment = {
      ...e.detail.comment,
      user: {
        username: e.detail.comment.username,
        email: e.detail.comment.email
      },
      publication_id: publicationId,
      created_at: new Date().toISOString()
    };

    try {
      const response = await api.post(`create_comment`, comment);
      comment.comment_id = response.comment_id;

      form = { success: 'Comment was created successfully' };
      comments = [comment, ...comments];
      
      toastStore.show('Comment created successfully!', 'success'); // Use toastStore for success message
    } catch (e) {
      form = { error: 'Username or email are in use' };
      toastStore.show(form.error, 'error'); // Use toastStore for error message
    }
  };
</script>

<svelte:head>
  <title>{title}</title>
</svelte:head>

<div class="article-page">
  <div class="banner">
    <div class="container">
      <h1>{title}</h1>
    </div>
  </div>

  <div class="container page">
    <div class="row article-content">
      <div class="col-xs-12">
        <Markdown source={content || ''} />
      </div>
    </div>

    <hr />

    <!-- Sección de comentarios -->
    <div class="row">
      <CommentContainer {comments} errors={[]} on:commentForm={loadNewComment} />
    </div>

    <!-- Botón para cargar más comentarios -->
    {#if currentPage <= totalPages}
      <div style="display: flex; justify-content: center;">
        <button class="btn btn-primary" on:click={loadComments} disabled={loading}>
          {#if loading}
            Loading...
          {:else}
            Load more comments...
          {/if}
        </button>
      </div>
    {/if}
  </div>

  <!-- The Toast component no longer needs to manage state manually -->
  <Toast />
</div>
