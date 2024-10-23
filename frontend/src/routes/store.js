import { writable } from 'svelte/store';

// export const publicationStore = writable(null);
export const isLoading = writable(false);

export function localStorageStore(key, initial) {
    const value = localStorage.getItem(key)
    const store = writable(value == null ? initial : value);
    store.subscribe(v => {
        if (v == undefined) {
            localStorage.removeItem(key);
            return;
        }
        localStorage.setItem(key, v)
    });
        
    return store;
}

export const token = localStorageStore('token', null);
export const refreshToken = localStorageStore('refreshToken', null);

const createToastStore = () => {
  const { subscribe, set, update } = writable({
    message: '',
    type: 'success',
    visible: false,
  });

  return {
    subscribe,
    show: (message, type = 'success') => {
      set({ message, type, visible: true });

      // Automatically hide the toast after 3 seconds
      setTimeout(() => {
        update((state) => ({ ...state, visible: false }));
      }, 3000);
    },
    hide: () => set({ message: '', type: 'success', visible: false }),
  };
};

export const toastStore = createToastStore();
