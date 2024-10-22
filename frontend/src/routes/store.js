import { writable } from 'svelte/store';

// export const publicationStore = writable(null);
export const isLoading = writable(false);

export function localStorageStore(key, initial) {
    const value = localStorage.getItem(key)
    const store = writable(value == null ? initial : value);
    store.subscribe(v => {
        if (v == null) {
            localStorage.removeItem(key);
            return;
        }
        localStorage.setItem(key, v)
    });
        
    return store;
}

export const token = localStorageStore('token', null);
export const refreshToken = localStorageStore('refreshToken', null);