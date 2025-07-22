// Entry point for the build script in your package.json

// import Rails from "@rails/ujs"
// import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "./channels"
import Rails from "@rails/ujs"

Rails.start()
// Turbolinks.start()
ActiveStorage.start()

import 'bootstrap'

// CSS
// import 'scss/site'

// JS
import './js/site'

// Images
const images = require.context('./images', true)
const imagePath = (name) => images(name, true)

import { singleFileUpload, multipleFileUpload } from './fileUpload'

// Use 'DOMContentLoaded' event if not using Turbolinks
document.addEventListener('turbolinks:load', () => {
  document.querySelectorAll('input[type=file]').forEach(fileInput => {
    if (fileInput.multiple) {
      multipleFileUpload(fileInput)
    } else {
      singleFileUpload(fileInput)
    }
  })
})
