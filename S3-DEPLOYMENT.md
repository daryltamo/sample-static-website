# S3 Deployment Setup Instructions

This repository includes a GitHub Action that automatically deploys your static website to Amazon S3 when code is pushed to the `main` branch.

## Prerequisites

1. **AWS Account**: You need an AWS account with S3 access
2. **S3 Bucket**: Create an S3 bucket configured for static website hosting
3. **IAM User**: Create an IAM user with programmatic access and appropriate permissions

## Setup Steps

### 1. Create S3 Bucket

1. Go to AWS S3 Console
2. Create a new bucket (e.g., `your-website-bucket-name`)
3. Enable static website hosting:
   - Go to Properties → Static website hosting
   - Enable it and set `index.html` as the index document
   - Optionally set `404.html` as the error document

### 2. Configure Bucket Policy (for public access)

Add this bucket policy to make your website publicly accessible:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "PublicReadGetObject",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::your-website-bucket-name/*"
    }
  ]
}
```

### 3. Create IAM User

1. Go to AWS IAM Console
2. Create a new user with programmatic access
3. Attach this policy to the user:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:PutObjectAcl",
        "s3:GetObject",
        "s3:DeleteObject",
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::your-website-bucket-name",
        "arn:aws:s3:::your-website-bucket-name/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "cloudfront:CreateInvalidation"
      ],
      "Resource": "*"
    }
  ]
}
```

### 4. Configure GitHub Secrets

In your GitHub repository, go to Settings → Secrets and variables → Actions, and add these secrets:

- `AWS_ACCESS_KEY_ID`: Your IAM user's access key ID
- `AWS_SECRET_ACCESS_KEY`: Your IAM user's secret access key
- `AWS_REGION`: Your S3 bucket region (e.g., `us-east-1`)
- `S3_BUCKET_NAME`: Your S3 bucket name
- `CLOUDFRONT_DISTRIBUTION_ID`: (Optional) Your CloudFront distribution ID for cache invalidation

### 5. Optional: CloudFront Setup

For better performance and HTTPS support:

1. Create a CloudFront distribution
2. Set your S3 bucket as the origin
3. Configure default root object as `index.html`
4. Add the distribution ID to GitHub secrets as `CLOUDFRONT_DISTRIBUTION_ID`

## How It Works

The GitHub Action will:

1. Trigger on every push to the `main` branch
2. Check out your code
3. Configure AWS credentials using the secrets
4. Sync all files to your S3 bucket (excluding git files and README)
5. Optionally invalidate CloudFront cache for immediate updates

## File Structure

After deployment, your S3 bucket will contain:

- `index.html` (main page)
- `assets/` (CSS, JS, images, fonts)
- `images/` (website images)
- All other HTML files

## Testing

1. Push changes to the `main` branch
2. Check the Actions tab in your GitHub repository
3. Verify the deployment succeeded
4. Visit your S3 website URL or CloudFront URL

## Troubleshooting

- **Access Denied**: Check your IAM user permissions and bucket policy
- **Bucket Not Found**: Verify the bucket name in secrets matches exactly
- **Region Mismatch**: Ensure the AWS region matches your bucket's region
- **CloudFront Issues**: Verify the distribution ID is correct (if using CloudFront)

## Security Notes

- Never commit AWS credentials to your repository
- Use IAM roles with minimal required permissions
- Consider using AWS IAM roles for GitHub Actions (OIDC) for enhanced security
- Regularly rotate your access keys