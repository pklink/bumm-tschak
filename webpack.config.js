module.exports = {
    entry: {
        app: './src/app.coffee'
    },
    output: {
        path:     __dirname,
        filename: 'bundle.js'
    },
    module: {
        loaders: [
            {
                test: /\.html?$/,
                loader: 'raw'
            },
            {
                test:   /\.coffee/,
                loader: 'coffee-loader',
                include: __dirname + '/src',
                exclude: /(node_modules)/
            }
        ]
    }
};
