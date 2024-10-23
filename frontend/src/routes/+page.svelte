<script>
  import { enhance } from '$app/forms';
  import { page } from '$app/stores';
  import ArticleList from '$lib/ArticleList/index.svelte';
  import Pagination from './Pagination.svelte';
  import { Carta, MarkdownEditor } from 'carta-md';
  import { attachment } from '@cartamd/plugin-attachment';
  import 'carta-md/default.css';
  import '@cartamd/plugin-attachment/default.css';
  import Toast from './Toast.svelte';
  import Searchbar from './Searchbar.svelte';
  import * as api from '$lib/api';
  import { afterNavigate, goto } from '$app/navigation';
  import { token, toastStore } from './store';  // Import the toastStore

  $: isAuthenticated = $token != undefined;

  const carta = new Carta({
    extensions: [
      attachment({
        upload: async (file) => {
          const formData = new FormData();
          formData.append('image', file);

          if (!['png', 'jpg', 'jpeg', 'gif'].includes(file.name.split('.').pop()) || file.size > 20 * 1024 * 1024)
            return 'Unsupported file type or size';

          const url = await uploadImage(formData);
          return url;
        }
      })
    ]
  });

  const uploadImage = async (formData) => {
    try {
      const file = formData.get('image');
      const buffer = await file.arrayBuffer();
      const base64Image = btoa(new Uint8Array(buffer).reduce((data, byte) => data + String.fromCharCode(byte), ''));

      const extension = file.name.split('.').pop();

      const response = await api.post(`upload_image`, {
        image_data: base64Image,
        file_type: extension
      });

      return response.url;

    } catch (error) {
      console.error('Error uploading image:', error);
      return null;
    }
  };

  let data;
  let form;
  let showModal = false;
  let tag, tab, p, page_link_base, searchTerm;
  let publications;

  $: p = +($page.url.searchParams.get('page') ?? '1');
  $: searchTerm = $page.url.searchParams.get('search') ?? '';
  $: publications = data?.publications ?? [];

  function toggleModal() {
    showModal = !showModal;
    if (showModal) {
      document.body.style.overflow = 'hidden';
    } else {
      document.body.style.overflow = '';
    }
  }

  afterNavigate(async () => {
    const q = new URLSearchParams();
    q.set('page', p);
    if (searchTerm) q.set('search_term', searchTerm);

    const { publications, total_pages, total_publications } = await api.get(`get_publications?${q}`);
    const tags = [];

    data = {
      publications,
      pages: total_pages,
      tags
    };
  });

  const createPublication = async (e) => {
    e.preventDefault();
    const data = new FormData(e.target);

    try {
      const response = await api.post(`create_publication`, {
        title: data.get('title'),
        content: data.get('content')
      });
      document.body.style.overflow = '';
      goto(`/publications/${response.publication_id}`);

      // Show success toast
      toastStore.show('Publication created successfully!', 'success');
      
    } catch (e) {
      form = { error: "Username or email are in use" };

      // Show error toast using the toastStore
      toastStore.show('Username or email are in use!', 'error');
    }
  };
</script>

<svelte:head>
  <title>Soul Pupils</title>
</svelte:head>

<div class="home-page">
  <div class="banner">
    <div class="container">
      <h1 class="logo-font">Soul Pupils</h1>
      <p>A place to discuss what matters</p>
    </div>
  </div>

  <div class="container page">
    <div class="row">
      <div class="col-md-9">
        {#if data}
          <ArticleList publications={data.publications} />
          {#key p}
            <Pagination pages={data.pages} {p} href={(p) => `/?page=${p}`} />
          {/key}
        {/if}
      </div>

      <div class="col-md-3">
        <Searchbar {searchTerm} href={(t) => `/?search=${t}`} />
        {#if isAuthenticated}
          <button class="btn btn-lg btn-primary btn-block" on:click={toggleModal} type="button">
            Create Publication
          </button>
        {/if}

        <!-- Modal for Creating Publication -->
        {#if showModal}
          <div class="modal" role="dialog">
            <div class="modal-content">
              <span class="close" on:click={toggleModal} role="button" tabindex="0" aria-label="Close" aria-hidden="true" aria-controls="modal">&times;</span>
              <h2>Create New Publication</h2>
              <form method="POST" action="?/createPublication" on:submit={createPublication}>
                <div>
                  <label for="title">Title</label>
                  <input type="text" id="title" name="title" class="form-control" required />
                </div>
                <div>
                  <label for="content">Content</label>
                  <MarkdownEditor {carta} textarea={{ name: "content", required: true }} />
                </div>
                <div class="form-group">
                  <button class="btn btn-primary" type="submit">Submit</button>
                  <button class="btn btn-secondary" type="button" on:click={toggleModal}>Cancel</button>
                </div>
              </form>
            </div>
          </div>
        {/if}
      </div>
    </div>
  </div>

  <!-- Toast Component (handles toast display automatically via toastStore) -->
  <Toast />
</div>

<style>
  .modal {
    display: block;
    position: fixed;
    z-index: 1;
    left: 0;
    top: 0;
    width: 100%;
    height: 100%;
    overflow: auto;
    background-color: rgba(0, 0, 0, 0.4);
  }

  .modal-content {
    background-color: #fefefe;
    margin: 5% auto;
    padding: 20px;
    border: 1px solid #888;
    width: 80%;
  }

  .close {
    color: #aaa;
    float: right;
    font-size: 28px;
    font-weight: bold;
  }

  .close:hover,
  .close:focus {
    color: black;
    text-decoration: none;
    cursor: pointer;
  }

  button {
    margin: 10px 0;
  }

  .btn-block {
    width: 100%;
    margin-bottom: 20px;
  }

  :global(.carta-wrapper) {
    height: 400px;
    overflow: auto;
  }

  :global(.carta-container) {
    height: 400px;
    overflow: hidden;
  }

  :global(.carta-font-code) {
    font-family: '...', monospace;
    font-size: 1.1rem;
  }

  :global(.carta-input, .carta-renderer) {
    height: 400px !important;
  }

  :global(.carta-theme__default .carta-container > *) {
    margin: 0;
    padding: 10px;
  }
</style>
