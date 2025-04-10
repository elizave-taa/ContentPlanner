const esbuild = require('esbuild');
const vuePlugin = require('esbuild-plugin-vue3');

async function build() {
    const ctx = await esbuild.context({
        entryPoints: ['app/javascript/application.js'],
        bundle: true,
        sourcemap: true,
        format: 'esm',
        outdir: 'app/assets/builds',
        publicPath: '/assets',
        plugins: [vuePlugin()]
    });

    if (process.argv.includes('--watch')) {
        console.log('Starting watch mode...');
        await ctx.watch();
    } else {
        console.log('Building...');
        await ctx.rebuild();
        ctx.dispose();
    }
}

build().catch((error) => {
    console.error('Build failed:', error);
    process.exit(1);
});