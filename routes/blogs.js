const express = require('express');
const router = express.Router();
const verifyToken = require('../middleware/verifyToken');

const { createBlog, getBlogs, getSingleBlog, deleteBlog, patchBlog, getBlogByTitle,savedBlog,getSavedBlogs } = require('../controllers/blogs');


router.route('/').post(verifyToken,createBlog).get(verifyToken,getBlogs);

router.route('/search').get(verifyToken,getBlogByTitle);
router.route('/save/:blogID').patch(verifyToken,savedBlog);
router.route('/saved').get(verifyToken,getSavedBlogs);
router.route('/:blogID').get(verifyToken,getSingleBlog).delete(verifyToken,deleteBlog).patch(verifyToken,patchBlog);

module.exports = router;