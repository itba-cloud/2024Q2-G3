<script>
  export let href;
  export let searchTerm = '';

  const handleSearch = () => {
    window.location.href = href(searchTerm);
  };

  const handleKeyDown = (event) => {
    if (event.key === 'Enter') {
      handleSearch();
    }
  };
</script>

<div class="input-group mb-3">
  <input
    type="text"
    class="form-control"
    placeholder="Type a keyword..."
    bind:value={searchTerm}
    on:keydown={handleKeyDown}
    aria-label="Search"
  />
  <button class="btn btn-primary" type="button" on:click={handleSearch}>
    Search
  </button>
</div>

<style>
  .input-group {
    max-width: 500px;
    margin: 0 auto;
  }

  .form-control {
    border-radius: 0.375rem 0 0 0.375rem;
    z-index: 0;
  }

  .btn-primary {
    border-radius: 0 0.375rem 0.375rem 0;
  }
</style>
