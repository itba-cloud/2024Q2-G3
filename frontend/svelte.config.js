// import adapter from '@sveltejs/adapter-node';
import adapter from '@sveltejs/adapter-static';


/** @type {import('@sveltejs/kit').Config} */
export default {
	kit: {
		// adapter: adapter({ runtime: 'edge' })
		adapter: adapter({
			fallback: 'index.html',
		}),
		csrf: {
		  checkOrigin: false,
		}
	}
};
