const {environment} = require('@rails/webpacker')

const webpack = require('webpack')

environment.plugins.append('Provide',
    new webpack.ProvidePlugin({
        $: 'jquery',
        jQuery: 'jquery',
        Popper: ['popper.js', 'default']
    })
)

module.exports = environment

// const { environment } = require("@rails/webpacker");
// const webpack = require("webpack");

// // Add an additional plugin of your choosing : ProvidePlugin
// environment.plugins.prepend(
//   "Provide",
//   new webpack.ProvidePlugin({
//     $: "jquery",
//     jQuery: "jquery",
//     jquery: "jquery",
//     "window.Tether": "tether",
//     Popper: ["popper.js", "default"] // for Bootstrap 4
//   })
// );

// module.exports = environment;
