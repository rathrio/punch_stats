const path = require("path");
const HtmlWebPackPlugin = require("html-webpack-plugin");

module.exports = {
  mode: 'development',
  entry: ["./ui/src/index.ts"],
  output: {
    path: path.resolve(__dirname, "ui/dist"),
    filename: "[hash].bundle.js"
  },
  module: {
    rules: [
      {
        test: /\.(j|t)sx?$/,
        exclude: /node_modules/,
        loader: "awesome-typescript-loader"
      },
      {
        test: /\.html$/,
        exclude: /node_modules/,
        use: ["html-loader"]
      },
      {
        test: /\.scss$/,
        exclude: /node_modules/,
        use: [
          "style-loader", // creates style nodes from JS strings
          "css-loader", // translates CSS into CommonJS
          "sass-loader" // compiles Sass to CSS
        ]
      },
      {
        test: /\.jpe?g$|\.ico$|\.gif$|\.png$|\.svg$|\.woff$|\.ttf$|\.wav$|\.mp3$/,
        loader: 'file-loader?name=[name].[ext]'
      }
    ]
  },
  resolve: {
    extensions: [".ts", ".js", ".tsx", ".wasm", ".mjs", ".json"]
  },
  plugins: [
    new HtmlWebPackPlugin({
      template: "./ui/src/index.html"
    })
  ]
};
