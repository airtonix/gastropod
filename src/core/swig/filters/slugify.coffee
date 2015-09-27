###
 Swig Slugify Filter
###

slug = require 'slug'

module.exports = (input) -> slug input, lower: true
