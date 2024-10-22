<script>
  export let message = '';
  export let visible = false;
  export let type = 'success';
  
  // Hide the toast after 3 seconds
  $: if (visible) {
    setTimeout(() => {
      visible = false;
    }, 3000);
}

</script>

{#if visible}
  <div class="toast {type}">
    {message}
  </div>
{/if}

<style>
  .toast {
    position: fixed;
    bottom: 20px;
    right: 20px;
    color: white;
    padding: 15px;
    border-radius: 5px;
    z-index: 1000;
    opacity: 1;
    transition: opacity 0.3s ease; /* Optional: Add a fade effect */
  }

  .toast.error {
    background-color: #dc3545; /* Red background for error */
  }

  .toast.success {
    background-color: green;
  }
</style>
