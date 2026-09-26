# -----------------------------
# IAM Policy for Backend S3 Access
# -----------------------------

resource "aws_iam_policy" "backend_s3" {
  name        = "prod-eks-rabi-s3-policy"
  description = "S3 access for FastAPI backend"

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "s3:ListBucket"
        ]

        Resource = aws_s3_bucket.demo.arn
      },
      {
        Effect = "Allow"

        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]

        Resource = "${aws_s3_bucket.demo.arn}/*"
      }
    ]
  })
}

# -----------------------------
# Trust Policy (IRSA)
# -----------------------------

data "aws_iam_policy_document" "backend_irsa" {

  statement {

    actions = ["sts:AssumeRoleWithWebIdentity"]

    effect = "Allow"

    principals {
      type = "Federated"

      identifiers = [
        aws_iam_openid_connect_provider.eks.arn
      ]
    }

    condition {
      test = "StringEquals"

      variable = "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:sub"

      values = [
        "system:serviceaccount:app:backend-sa"
      ]
    }

    condition {
      test = "StringEquals"

      variable = "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:aud"

      values = [
        "sts.amazonaws.com"
      ]
    }
  }
}

# -----------------------------
# IAM Role
# -----------------------------

resource "aws_iam_role" "backend_s3" {

  name = "prod-eks-rabi-s3-role"

  assume_role_policy = data.aws_iam_policy_document.backend_irsa.json
}

resource "aws_iam_role_policy_attachment" "backend_s3" {

  role = aws_iam_role.backend_s3.name

  policy_arn = aws_iam_policy.backend_s3.arn
}

