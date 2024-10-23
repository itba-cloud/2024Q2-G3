<script>
  import { toastStore } from '../routes/store';
  let message = '';
  let visible = false;
  let type = 'success';

  // Subscribing to the toastStore to get the current toast data
  $: toastStore.subscribe(({ message: newMessage, type: newType, visible: newVisible }) => {
    message = newMessage;
    type = newType;
    visible = newVisible;
  });
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
