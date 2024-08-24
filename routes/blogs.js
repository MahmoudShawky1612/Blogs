const express = require('express');
const router = express.Router();
const verifyToken = require('../middleware/verifyToken');

const { createBlog, getBlogs, getSingleBlog, deleteBlog, patchBlog, getBlogByTitle,savedBlog,getSavedBlogs } = require('../controllers/blogs');


router.route('/').post(createBlog).get(getBlogs);

router.route('/search').get(getBlogByTitle);
router.route('/save/:blogID').patch(savedBlog);
router.route('/saved').get(getSavedBlogs);
router.route('/:blogID').get(getSingleBlog).delete(deleteBlog).patch(patchBlog);

module.exports = router;