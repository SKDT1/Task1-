resource "google_storage_bucket" "da_struggle_is_real" {
  name = "tf-da-struggle-is-real"
  location = "us-west4"
  force_destroy = "true"
  storage_class = "standard"
   labels = {
    "env" = "tf_env"
    "dep" = "test"
    }    
  website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }
  uniform_bucket_level_access = true
}

#uploading items to cloud bucket

 resource "google_storage_bucket_object" "picture" {
  name = "british_girl"
  bucket = google_storage_bucket.da_struggle_is_real.name
  source = "british.jpg"
}

 resource "google_storage_bucket_object" "picture1" {
  name = "beach_caribbean"
  bucket = google_storage_bucket.da_struggle_is_real.name
  source = "beach.jpg"
}

 #setting the bucket ACL to public read
 resource "google_storage_bucket_acl" "da_struggle_is_real" {
  bucket         = google_storage_bucket.da_struggle_is_real.name
  predefined_acl = "publicRead"
}

 #Uploading and setting public read access for HTML files

 resource "google_storage_bucket_object" "upload_html" {
  for_each     = fileset("${path.module}/", "*.html")
  bucket       = google_storage_bucket.da_struggle_is_real.name
  name         = each.value
  source       = "${path.module}/${each.value}"
  content_type = "text/html"
}

 #Public ACL for each HTML file
 resource "google_storage_object_acl" "html_acl" {
  for_each       = google_storage_bucket_object.upload_html
  bucket         = google_storage_bucket_object.upload_html[each.key].bucket
  object         = google_storage_bucket_object.upload_html[each.key].name
  predefined_acl = "publicRead"
}

 #Uploading and setting public read access for image files
 resource "google_storage_bucket_object" "upload_images" {
  for_each     = fileset("${path.module}/", "*.jpg")
  bucket       = google_storage_bucket.da_struggle_is_real.name
  name         = each.value
  source       = "${path.module}/${each.value}"
  content_type = "image/jpeg"
}

 #Public ACL for each image file
resource "google_storage_object_acl" "image_acl" {
  for_each       = google_storage_bucket_object.upload_images
  bucket         = google_storage_bucket_object.upload_images[each.key].bucket
  object         = google_storage_bucket_object.upload_images[each.key].name
  predefined_acl = "publicRead"
}


 output "website_url" {
  value = "https://storage.googleapis.com/${google_storage_bucket.da_struggle_is_real.name}/index.html"
}

 