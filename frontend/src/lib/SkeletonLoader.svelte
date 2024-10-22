<script>
  export let loading = false;
</script>

<style>
  .overlay {
    position: fixed;
    top: 0;
    left: 0;
    width: 100vw;
    height: 100vh;
    background-color: rgba(0, 0, 0, 0.7);
    display: flex;
    align-items: center;
    justify-content: center;
    z-index: 1000;
  }

  .eye-container {
    position: relative;
    width: 100px;
    height: 100px;
  }

  .eye {
    width: 100px;
    height: 100px;
    border-radius: 50%;
    background: radial-gradient(circle, #fff 60%, #000 62%);
    border: 5px solid #fff;
    position: absolute;
    top: 0;
    left: 0;
    animation: spin-eye 2s linear infinite;
  }

  .pupil {
    position: absolute;
    top: 25px;
    left: 25px;
    width: 50px;
    height: 50px;
    border-radius: 50%;
    background-color: #5cb85c;
    animation: spin-pupil 2s linear infinite;
  }

  @keyframes spin-eye {
    0% {
      transform: rotate(0deg);
    }
    100% {
      transform: rotate(360deg);
    }
  }

  @keyframes spin-pupil {
    0% {
      transform: rotate(360deg);
    }
    100% {
      transform: rotate(0deg);
    }
  }
</style>

{#if loading}
  <div class="overlay">
    <div class="eye-container">
      <div class="eye">
        <div class="pupil"></div>
      </div>
    </div>
  </div>
{/if}