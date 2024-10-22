import { sveltekit } from '@sveltejs/kit/vite';

/** @type {import('vite').UserConfig} */
const config = {
	plugins: [sveltekit()],
	define: {
		__ENABLE_CARTA_SSR_HIGHLIGHTER__: false
	}
};



export default config;
