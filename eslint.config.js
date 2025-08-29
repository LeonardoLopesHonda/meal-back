// https://docs.expo.dev/guides/using-eslint/
const { defineConfig } = require("eslint/config");
const expoConfig = require("eslint-config-expo/flat");
const eslintPluginPrettierRecommended = require("eslint-plugin-prettier/recommended");
const prettierPlugin = require("eslint-plugin-prettier");

module.exports = defineConfig([
  expoConfig,
  eslintPluginPrettierRecommended,
  {
    plugins: {
      prettier: prettierPlugin,
    },
    rules: { "prettier/prettier": "error" },
    ignores: ["dist/*"],
  },
]);
