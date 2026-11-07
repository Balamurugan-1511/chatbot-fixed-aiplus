-- MySQL dump 10.13  Distrib 8.0.46, for Win64 (x86_64)
--
-- Host: localhost    Database: skandaplus
-- ------------------------------------------------------
-- Server version	8.0.46

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `batches`
--

DROP TABLE IF EXISTS `batches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `batches` (
  `id` int NOT NULL AUTO_INCREMENT,
  `course_id` int NOT NULL,
  `start_date` datetime(3) NOT NULL,
  `mode` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'online',
  `timing` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `seats_left` int DEFAULT NULL,
  `status` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'upcoming',
  `note` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  KEY `batches_course_id_start_date_idx` (`course_id`,`start_date`),
  CONSTRAINT `batches_course_id_fkey` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `batches`
--

LOCK TABLES `batches` WRITE;
/*!40000 ALTER TABLE `batches` DISABLE KEYS */;
/*!40000 ALTER TABLE `batches` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `blogs`
--

DROP TABLE IF EXISTS `blogs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `blogs` (
  `id` int NOT NULL AUTO_INCREMENT,
  `author_id` int NOT NULL,
  `slug` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `title` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `category` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `excerpt` text COLLATE utf8mb4_unicode_ci,
  `body` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `image_url` text COLLATE utf8mb4_unicode_ci,
  `image_alt` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'published',
  `published_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  UNIQUE KEY `blogs_slug_key` (`slug`),
  KEY `blogs_author_id_idx` (`author_id`),
  CONSTRAINT `blogs_author_id_fkey` FOREIGN KEY (`author_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `blogs`
--

LOCK TABLES `blogs` WRITE;
/*!40000 ALTER TABLE `blogs` DISABLE KEYS */;
INSERT INTO `blogs` VALUES (1,1,'ai-career-pune-guide','How to Start a Career in AI in Pune: A Complete 2025 Guide','Career Guide','Pune is one of the best places in the world to build an AI career. Here\'s everything you need to know about breaking into the field.','Pune\'s tech ecosystem ΓÇö home to global IT majors, fast-growing product startups, and research institutions ΓÇö has made it one of India\'s most active hubs for AI hiring.\n\nThis guide walks through the core skills employers look for, how to structure a beginner-friendly learning path, and how to build a portfolio of real projects that stands out to hiring managers.\n\nWhether you are switching careers from a non-technical background or upskilling as a software engineer, the fastest path into AI roles is consistent, project-based learning paired with mentorship and honest feedback on your work.','https://img.rocket.new/generatedImages/rocket_gen_img_176e3b618-1766381641204.png','AI career guide showing neural network visualization with career path arrows','published','2026-10-16 06:47:34.862'),(2,1,'llm-comparison-2025','GPT-4o vs Claude 3.5 vs Gemini 1.5: Which LLM Should You Use?','Artificial Intelligence','A comprehensive comparison of the top large language models in 2025, with benchmarks and practical use case recommendations.','Choosing the right large language model depends heavily on your use case ΓÇö reasoning-heavy tasks, long-context document analysis, and cost-sensitive high-volume applications each favour different models.\n\nIn our Generative AI & LLMs course, students get hands-on practice benchmarking multiple models against real tasks, so the choice becomes a matter of data rather than hype.\n\nThis post breaks down practical trade-offs across latency, cost, context window, and reasoning quality to help you pick the right model for your next project.','https://img.rocket.new/generatedImages/rocket_gen_img_1812c8ac3-1783933499611.png','Comparison of large language models GPT Claude and Gemini on a digital interface','published','2026-10-16 06:47:34.867'),(3,1,'india-ai-governance','India\'s AI Governance Landscape: What You Need to Know','AI Policy','NITI Aayog\'s Responsible AI framework explained for business leaders and AI practitioners operating in India.','As AI adoption accelerates across Indian industry, understanding the evolving policy landscape ΓÇö including data protection under the DPDP Act and sector-specific AI guidance ΓÇö is becoming essential for anyone deploying AI in production.\n\nOur AI for Business Leaders course covers these governance fundamentals so teams can build and deploy AI responsibly, with fewer compliance surprises down the line.','https://img.rocket.new/generatedImages/rocket_gen_img_1e0cd917b-1783933503817.png','Government building representing AI governance and policy framework','published','2026-10-16 06:47:34.872'),(4,1,'rag-vs-finetuning','RAG vs Fine-tuning: When to Use Each Approach','Machine Learning','A practical guide to choosing between Retrieval-Augmented Generation and fine-tuning for your LLM application.','Retrieval-Augmented Generation (RAG) and fine-tuning solve different problems: RAG is ideal when your knowledge base changes frequently and you need traceable sources, while fine-tuning suits cases where you need a model to consistently adopt a style, format, or specialised skill.\n\nIn practice, many production systems combine both. This post walks through a simple decision framework based on data freshness, latency budget, and how much labelled training data you have available.','https://img.rocket.new/generatedImages/rocket_gen_img_183666888-1783933500933.png','Machine learning engineer comparing RAG and fine-tuning approaches on a whiteboard','published','2026-10-16 06:47:34.876'),(5,1,'top-ai-skills-pune-2025','Top 10 AI Skills Pune Employers Are Looking For in 2025','Career Guide','Based on analysis of 500+ job postings from Pune\'s top tech companies, here are the AI skills in highest demand.','From Python and prompt engineering to MLOps and vector databases, hiring patterns across Pune-based tech companies show a clear shift toward practical, deployment-ready AI skills rather than purely theoretical knowledge.\n\nThis post ranks the ten most-requested skills and links each to the AI Plus course that covers it, so you can map your learning plan directly to what employers are hiring for.','https://img.rocket.new/generatedImages/rocket_gen_img_1f82b08b0-1783933502003.png','Students learning AI skills in a technology training classroom','published','2026-10-16 06:47:34.880'),(6,1,'rag-langchain-pinecone-tutorial','Building Your First RAG Application with LangChain and Pinecone','Tutorial','Step-by-step tutorial to build a production-ready RAG system that answers questions from your own documents.','This hands-on tutorial walks through building a Retrieval-Augmented Generation pipeline: chunking and embedding your documents, storing vectors in Pinecone, and wiring retrieval into an LLM prompt using LangChain.\n\nIt is adapted from a project module in our Generative AI & LLMs course, where students build and deploy a working RAG app by the end of the first module.','https://img.rocket.new/generatedImages/rocket_gen_img_113433f4c-1783933501457.png','Developer building a RAG application with LangChain showing code on screen','published','2026-10-16 06:47:34.884');
/*!40000 ALTER TABLE `blogs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `chat_messages`
--

DROP TABLE IF EXISTS `chat_messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `chat_messages` (
  `id` int NOT NULL AUTO_INCREMENT,
  `session_id` int NOT NULL,
  `role` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `content` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  KEY `chat_messages_session_id_id_idx` (`session_id`,`id`),
  CONSTRAINT `chat_messages_session_id_fkey` FOREIGN KEY (`session_id`) REFERENCES `chat_sessions` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chat_messages`
--

LOCK TABLES `chat_messages` WRITE;
/*!40000 ALTER TABLE `chat_messages` DISABLE KEYS */;
INSERT INTO `chat_messages` VALUES (1,1,'user','Courses','2026-10-23 15:40:54.406'),(2,1,'assistant','Sorry, I\'m having trouble replying right now. Please try again in a moment, or use the Contact page to reach our team.','2026-10-23 15:40:55.574'),(3,2,'user','hi','2026-11-06 15:26:01.180'),(4,2,'assistant','Sorry, I\'m having trouble replying right now. Please try again in a moment, or use the Contact page to reach our team.','2026-11-06 15:26:01.810'),(5,2,'user','hi','2026-11-06 15:31:20.768'),(6,2,'assistant','Sorry, I\'m having trouble replying right now. Please try again in a moment, or use the Contact page to reach our team.','2026-11-06 15:31:21.524'),(7,2,'user','Courses','2026-11-06 15:31:26.195'),(8,2,'assistant','Sorry, I\'m having trouble replying right now. Please try again in a moment, or use the Contact page to reach our team.','2026-11-06 15:31:26.948'),(9,2,'user','Fees & Batches','2026-11-06 15:31:31.043'),(10,2,'assistant','Sorry, I\'m having trouble replying right now. Please try again in a moment, or use the Contact page to reach our team.','2026-11-06 15:31:31.759'),(11,2,'user','hi','2026-11-06 15:33:59.314'),(12,2,'assistant','Hello! Welcome to AI Plus. I can help you find the right course to start or advance your career in AI.\n\nAre you looking for a beginner-level course or something more advanced?','2026-11-06 15:34:00.768'),(13,2,'user','Courses','2026-11-06 15:34:10.141'),(14,2,'assistant','We offer several specialized courses in AI and Machine Learning. Here are a few options:\n\n- AI Fundamentals & Python for AI: Master the foundations of AI and Python programming in 6 weeks.\n- Generative AI & Large Language Models: Learn to build applications using technology like ChatGPT and Claude over 8 weeks.\n- Machine Learning Engineering: A 10-week course focused on building and deploying production-ready models.\n\nWould you like to know the fee for any of these, or should I connect you with a counselor?','2026-11-06 15:34:12.125'),(15,2,'user','Talk to a Counsellor','2026-11-06 15:34:39.731'),(16,2,'assistant','Great, I\'ve let one of our counselors know you\'re interested in joining. Please share your name and phone number so they can contact you.','2026-11-06 15:34:39.789');
/*!40000 ALTER TABLE `chat_messages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `chat_sessions`
--

DROP TABLE IF EXISTS `chat_sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `chat_sessions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `token` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `channel` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'web',
  `ip` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  UNIQUE KEY `chat_sessions_token_key` (`token`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chat_sessions`
--

LOCK TABLES `chat_sessions` WRITE;
/*!40000 ALTER TABLE `chat_sessions` DISABLE KEYS */;
INSERT INTO `chat_sessions` VALUES (1,'e895fb8cdb1daf03f8581ce98c154d0b1ee8b5929695cd46','web','::ffff:192.168.0.102','2026-10-23 15:40:54.386','2026-10-23 15:40:54.386'),(2,'14dab823124c619ddd28a1e0344150bd0e8da21d2506d2a1','web','::ffff:172.20.80.1','2026-11-06 15:26:01.118','2026-11-06 15:26:01.118');
/*!40000 ALTER TABLE `chat_sessions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `counselors`
--

DROP TABLE IF EXISTS `counselors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `counselors` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `phone` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `counselors`
--

LOCK TABLES `counselors` WRITE;
/*!40000 ALTER TABLE `counselors` DISABLE KEYS */;
INSERT INTO `counselors` VALUES (1,'Manasi',NULL,NULL,1),(2,'Sana',NULL,NULL,1),(3,'Jemmy',NULL,NULL,1),(4,'Vinith',NULL,NULL,1),(5,'Ranjan',NULL,NULL,1),(6,'Nila',NULL,NULL,1);
/*!40000 ALTER TABLE `counselors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `course_materials`
--

DROP TABLE IF EXISTS `course_materials`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `course_materials` (
  `id` int NOT NULL AUTO_INCREMENT,
  `course_id` int NOT NULL,
  `title` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `file_url` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `sort_order` int NOT NULL DEFAULT '0',
  `uploaded_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  KEY `course_materials_course_id_idx` (`course_id`),
  CONSTRAINT `course_materials_course_id_fkey` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `course_materials`
--

LOCK TABLES `course_materials` WRITE;
/*!40000 ALTER TABLE `course_materials` DISABLE KEYS */;
/*!40000 ALTER TABLE `course_materials` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `courses`
--

DROP TABLE IF EXISTS `courses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `courses` (
  `id` int NOT NULL AUTO_INCREMENT,
  `slug` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `title` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `category` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `course_type` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'training',
  `description` text COLLATE utf8mb4_unicode_ci,
  `href` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `duration` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `price` decimal(10,2) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `cover_image_url` text COLLATE utf8mb4_unicode_ci,
  `long_description` json DEFAULT NULL,
  `what_you_learn` json DEFAULT NULL,
  `curriculum` json DEFAULT NULL,
  `tools` json DEFAULT NULL,
  `prerequisites` json DEFAULT NULL,
  `who_is_this_for` json DEFAULT NULL,
  `duration_days` int DEFAULT '30',
  `value_pitch` text COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id`),
  UNIQUE KEY `courses_slug_key` (`slug`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `courses`
--

LOCK TABLES `courses` WRITE;
/*!40000 ALTER TABLE `courses` DISABLE KEYS */;
INSERT INTO `courses` VALUES (1,'ai-fundamentals','AI Fundamentals & Python for AI','AI','training','Master the foundations of Artificial Intelligence and Python programming. This beginner-friendly course gives you the essential skills to start your AI career in Pune\'s booming tech industry.','/ai-courses/ai-fundamentals','6 weeks','Beginner',25000.00,1,'https://img.rocket.new/generatedImages/rocket_gen_img_15afdb008-1772093387845.png','[\"The AI Fundamentals & Python for AI course is designed for complete beginners who want to enter the exciting world of Artificial Intelligence. You\'ll learn the core concepts of AI and machine learning while building practical Python programming skills.\", \"By the end of this course, you\'ll have a solid understanding of how AI systems work, be able to write Python code for data analysis and basic ML models, and have a portfolio project to showcase to employers.\", \"This course is Flexible EMI available, making it accessible to all Indian professionals looking to upskill in AI.\"]','[\"Understand core AI and ML concepts\", \"Write Python code for AI applications\", \"Work with data using NumPy and Pandas\", \"Build and evaluate ML models\", \"Apply AI to real-world problems\", \"Use popular AI tools and frameworks\", \"Understand AI ethics and responsible use\", \"Build a portfolio AI project\"]','[{\"week\": \"Week 1-2\", \"title\": \"Introduction to AI & Python Foundations\", \"topics\": [\"What is Artificial Intelligence? History and evolution\", \"Types of AI: Narrow AI, General AI, and AGI\", \"Python programming fundamentals for AI\", \"NumPy, Pandas, and Matplotlib for data manipulation\", \"Setting up your AI development environment\"]}, {\"week\": \"Week 3-4\", \"title\": \"Core Machine Learning Concepts\", \"topics\": [\"Supervised vs unsupervised vs reinforcement learning\", \"Linear regression and classification algorithms\", \"Decision trees and random forests\", \"Model evaluation metrics and validation techniques\", \"Feature engineering and data preprocessing\"]}, {\"week\": \"Week 5\", \"title\": \"AI Applications & Tools\", \"topics\": [\"Computer vision fundamentals with OpenCV\", \"Natural language processing basics\", \"Introduction to neural networks\", \"AI APIs and pre-trained models\", \"Ethical AI and responsible development\"]}, {\"week\": \"Week 6\", \"title\": \"Capstone Project & Career Prep\", \"topics\": [\"End-to-end AI project development\", \"Portfolio building and GitHub setup\", \"AI career pathways in Pune\", \"Interview preparation and resume review\", \"Certification exam preparation\"]}]','[\"Python 3.11\", \"Jupyter Notebook\", \"NumPy\", \"Pandas\", \"Matplotlib\", \"Scikit-learn\", \"OpenCV\", \"Hugging Face\", \"Google Colab\", \"VS Code\"]','[\"No prior programming experience required\", \"Basic computer literacy (using a laptop/PC)\", \"Curiosity and willingness to learn\", \"A laptop with internet connection\"]','[\"Fresh graduates looking to enter AI field\", \"Working professionals wanting to upskill\", \"Career changers transitioning to tech\", \"Business professionals curious about AI\", \"Anyone who wants to understand AI fundamentals\"]',30,NULL),(2,'machine-learning','Machine Learning Engineering','AI','training','Build, train, and deploy production-ready machine learning models. Master the full ML lifecycle from data engineering to cloud deployment using industry-standard tools.','/ai-courses/machine-learning','10 weeks','Intermediate',55000.00,1,'https://img.rocket.new/generatedImages/rocket_gen_img_1dcfc864c-1772164169627.png','[\"The Machine Learning Engineering course takes you from ML fundamentals to production deployment. You\'ll master the complete ML lifecycle: data preparation, model training, evaluation, and deploying models to cloud platforms used by Pune\'s top tech companies.\", \"This course emphasises practical, production-grade skills. You\'ll work with real datasets from Pune\'s financial, retail, and healthcare sectors, and learn MLOps practices used by industry leaders.\"]','[\"Master advanced ML algorithms and ensemble methods\", \"Build production ML pipelines with Scikit-learn\", \"Train deep learning models with TensorFlow & PyTorch\", \"Deploy models to AWS SageMaker and GCP\", \"Implement MLOps with MLflow and Docker\", \"Monitor and maintain models in production\", \"Interpret ML models with SHAP and LIME\", \"Optimise hyperparameters systematically\"]','[{\"week\": \"Week 1-2\", \"title\": \"ML Foundations & Data Engineering\", \"topics\": [\"Supervised learning algorithms: regression, classification\", \"Unsupervised learning: clustering, dimensionality reduction\", \"Data preprocessing, cleaning, and feature engineering\", \"Train/test splits, cross-validation, and bias-variance tradeoff\", \"Scikit-learn deep dive: pipelines and transformers\"]}, {\"week\": \"Week 3-4\", \"title\": \"Advanced ML Algorithms & Ensemble Methods\", \"topics\": [\"Gradient boosting: XGBoost, LightGBM, CatBoost\", \"Support Vector Machines and kernel methods\", \"Ensemble methods: bagging, boosting, stacking\", \"Hyperparameter tuning with Optuna and GridSearchCV\", \"Model interpretability with SHAP and LIME\"]}, {\"week\": \"Week 5-6\", \"title\": \"Deep Learning with TensorFlow & PyTorch\", \"topics\": [\"Neural network architecture and backpropagation\", \"TensorFlow 2.x and Keras for model building\", \"PyTorch fundamentals and custom training loops\", \"Transfer learning and fine-tuning pre-trained models\", \"GPU training and mixed precision\"]}, {\"week\": \"Week 7-8\", \"title\": \"MLOps & Production Deployment\", \"topics\": [\"ML experiment tracking with MLflow and Weights & Biases\", \"Model serving with FastAPI and Docker\", \"Cloud deployment on AWS SageMaker and GCP Vertex AI\", \"CI/CD pipelines for ML models\", \"Monitoring model drift and performance in production\"]}]','[\"Python\", \"Scikit-learn\", \"TensorFlow\", \"PyTorch\", \"XGBoost\", \"MLflow\", \"Docker\", \"AWS SageMaker\", \"FastAPI\", \"Jupyter\", \"SHAP\", \"Optuna\"]','[]','[]',30,NULL),(3,'deep-learning','Deep Learning & Neural Networks','AI','training','Master the full spectrum of deep learning ΓÇö from CNNs and RNNs to Transformers and Diffusion Models. Build cutting-edge AI systems used by the world\'s leading technology companies.','/ai-courses/deep-learning','10 weeks','Advanced',65000.00,1,'https://img.rocket.new/generatedImages/rocket_gen_img_1d2ff8a91-1764660695242.png','[\"The Deep Learning & Neural Networks course is our most comprehensive AI program. You\'ll master the mathematical foundations and practical implementation of all major deep learning architectures ΓÇö from classic CNNs to state-of-the-art Transformers and Diffusion Models.\", \"You\'ll train models on real GPU hardware, work with large-scale datasets, and learn to deploy optimised models to production. This course prepares you for senior AI/ML engineer roles at Pune\'s top technology companies.\"]','[\"Build CNNs for computer vision tasks\", \"Implement RNNs, LSTMs for sequence modelling\", \"Master the Transformer architecture\", \"Fine-tune BERT, GPT, and vision transformers\", \"Build and train GANs and VAEs\", \"Understand diffusion models and stable diffusion\", \"Optimise models with quantisation and pruning\", \"Deploy models with TensorRT and ONNX\"]','[{\"week\": \"Week 1-2\", \"title\": \"Neural Network Foundations\", \"topics\": [\"Perceptrons, activation functions, and forward propagation\", \"Backpropagation and gradient descent variants\", \"Regularisation: dropout, batch normalisation, L1/L2\", \"Optimisers: Adam, RMSprop, SGD with momentum\", \"Building custom neural networks in PyTorch\"]}, {\"week\": \"Week 3-4\", \"title\": \"Convolutional Neural Networks (CNNs)\", \"topics\": [\"CNN architecture: convolutions, pooling, feature maps\", \"Image classification with ResNet, VGG, EfficientNet\", \"Object detection: YOLO, Faster R-CNN, SSD\", \"Image segmentation with U-Net\", \"Transfer learning and fine-tuning for computer vision\"]}, {\"week\": \"Week 5-6\", \"title\": \"Recurrent Networks & Sequence Models\", \"topics\": [\"RNNs, LSTMs, and GRUs for sequence data\", \"Time series forecasting with deep learning\", \"Attention mechanisms and self-attention\", \"The Transformer architecture from scratch\", \"BERT and GPT pre-training objectives\"]}, {\"week\": \"Week 7-8\", \"title\": \"Generative Models & Advanced Topics\", \"topics\": [\"Variational Autoencoders (VAEs)\", \"Generative Adversarial Networks (GANs)\", \"Diffusion models and stable diffusion\", \"Reinforcement learning fundamentals\", \"Deploying deep learning models at scale\"]}, {\"week\": \"Week 9-10\", \"title\": \"Capstone Projects & Industry Applications\", \"topics\": [\"End-to-end computer vision project\", \"NLP project with transformer models\", \"Model optimisation: quantisation and pruning\", \"Edge AI deployment with TensorRT\", \"Portfolio presentation and career guidance\"]}]','[\"PyTorch\", \"TensorFlow\", \"Keras\", \"CUDA\", \"Hugging Face\", \"OpenCV\", \"ONNX\", \"TensorRT\", \"Weights & Biases\", \"Colab Pro\", \"Docker\"]','[]','[]',30,NULL),(4,'generative-ai','Generative AI & Large Language Models','AI','training','Master the technology powering ChatGPT, Claude, and Gemini. Learn prompt engineering, RAG systems, LLM fine-tuning, and build production-ready GenAI applications that solve real business problems.','/ai-courses/generative-ai','8 weeks','Intermediate',55000.00,1,'https://img.rocket.new/generatedImages/rocket_gen_img_14f24f844-1768587883889.png','[\"Generative AI is transforming every industry. This course gives you the skills to build, deploy, and manage production GenAI applications. You\'ll work with the latest LLMs including GPT-4o, Claude 3.5, LLaMA 3, and Mistral, and learn to build RAG systems, AI agents, and fine-tuned models.\", \"Pune\'s financial, healthcare, and government sectors are rapidly adopting GenAI. This course prepares you to lead these initiatives with practical, production-grade skills.\"]','[\"Master advanced prompt engineering techniques\", \"Build RAG systems with vector databases\", \"Fine-tune LLMs with LoRA and QLoRA\", \"Create autonomous AI agents with LangChain\", \"Work with OpenAI, Anthropic, and Google APIs\", \"Deploy GenAI apps with safety guardrails\", \"Evaluate LLM applications with RAGAS\", \"Optimise costs and performance at scale\"]','[{\"week\": \"Week 1-2\", \"title\": \"Foundations of Generative AI & LLMs\", \"topics\": [\"History and evolution of language models\", \"Transformer architecture deep dive: attention, positional encoding\", \"GPT family: GPT-3, GPT-4, GPT-4o architecture and capabilities\", \"Open-source LLMs: LLaMA 3, Mistral, Gemma, Phi-3\", \"Tokenisation, embeddings, and vector representations\"]}, {\"week\": \"Week 3-4\", \"title\": \"Prompt Engineering & LLM APIs\", \"topics\": [\"Advanced prompt engineering techniques\", \"Chain-of-thought, few-shot, and zero-shot prompting\", \"OpenAI API, Anthropic Claude API, and Google Gemini API\", \"Structured outputs and function calling\", \"Cost optimisation and rate limiting strategies\"]}, {\"week\": \"Week 5-6\", \"title\": \"RAG Systems & Knowledge Bases\", \"topics\": [\"Retrieval-Augmented Generation (RAG) architecture\", \"Vector databases: Pinecone, Weaviate, ChromaDB\", \"Document chunking, embedding, and retrieval strategies\", \"Advanced RAG: HyDE, multi-query, reranking\", \"Building enterprise knowledge bases\"]}, {\"week\": \"Week 7-8\", \"title\": \"Fine-tuning, Agents & Production GenAI\", \"topics\": [\"Fine-tuning LLMs with LoRA and QLoRA\", \"LangChain and LlamaIndex for LLM applications\", \"Building autonomous AI agents with tool use\", \"Evaluation frameworks: RAGAS, TruLens\", \"Deploying GenAI apps to production with guardrails\"]}]','[\"OpenAI API\", \"LangChain\", \"LlamaIndex\", \"Pinecone\", \"ChromaDB\", \"Hugging Face\", \"LLaMA\", \"Mistral\", \"LoRA\", \"RAGAS\", \"FastAPI\", \"Streamlit\"]','[]','[]',30,NULL),(5,'ai-for-business','AI for Business Leaders','Business','training','Designed for executives, managers, and business professionals. Understand AI strategy, ROI, ethics, and how to lead successful AI transformation without needing to write a single line of code.','/ai-courses/ai-for-business','4 weeks','Beginner',45000.00,1,'https://img.rocket.new/generatedImages/rocket_gen_img_198ad9e76-1766563899922.png','[\"The AI for Business Leaders course is specifically designed for non-technical professionals who need to understand, evaluate, and lead AI initiatives. No coding required ΓÇö just strategic thinking and business acumen.\", \"You\'ll learn how to identify AI opportunities in your organisation, build a compelling AI business case, manage AI teams, and navigate the ethical and regulatory landscape in Pune.\"]','[\"Understand AI, ML, and GenAI without technical jargon\", \"Build a compelling AI strategy for your organisation\", \"Measure and communicate AI ROI to stakeholders\", \"Lead and manage AI teams effectively\", \"Navigate India\'s AI governance landscape\", \"Identify and prioritise AI use cases\", \"Manage AI risks and ethical considerations\", \"Drive successful AI change management\"]','[{\"week\": \"Week 1\", \"title\": \"AI Landscape for Business Leaders\", \"topics\": [\"What is AI, ML, and GenAI ΓÇö demystified for executives\", \"Current state of AI in Pune and across India\", \"AI maturity models and organisational readiness\", \"Key AI use cases across industries: finance, healthcare, retail\", \"Understanding AI capabilities and limitations\"]}, {\"week\": \"Week 2\", \"title\": \"AI Strategy & Business Value\", \"topics\": [\"Building an AI strategy aligned with business goals\", \"Identifying and prioritising AI opportunities\", \"AI ROI measurement frameworks\", \"Build vs buy vs partner decisions\", \"Creating an AI roadmap for your organisation\"]}, {\"week\": \"Week 3\", \"title\": \"Leading AI Teams & Projects\", \"topics\": [\"AI team structures: data scientists, ML engineers, AI product managers\", \"Managing AI projects: timelines, milestones, and KPIs\", \"Data strategy and data governance\", \"Vendor evaluation and AI procurement\", \"Change management for AI adoption\"]}, {\"week\": \"Week 4\", \"title\": \"AI Ethics, Risk & Governance\", \"topics\": [\"AI ethics frameworks and responsible AI principles\", \"India\'s evolving AI governance landscape (NITI Aayog)\", \"AI risk management and bias mitigation\", \"Regulatory compliance: the DPDP Act and AI regulations\", \"Building an AI governance committee\"]}]','[]','[]','[]',30,NULL),(6,'nlp','NLP & Conversational AI','AI','training','Build intelligent chatbots, voice assistants, and NLP pipelines. Master BERT, transformer models, and conversational AI frameworks to create systems that understand and generate human language.','/ai-courses/nlp','8 weeks','Intermediate',55000.00,1,'https://img.rocket.new/generatedImages/rocket_gen_img_179e37808-1767170142529.png','[\"Natural Language Processing is at the heart of the AI revolution. From customer service chatbots to document analysis systems, NLP powers the most impactful AI applications in Pune\'s banking, healthcare, and government sectors.\", \"This course has a special focus on Pune\'s multilingual context ΓÇö you\'ll learn to build NLP systems that handle English, Mandarin, Malay, and Tamil, making your skills uniquely valuable in the local market.\"]','[\"Master NLP fundamentals and text processing\", \"Fine-tune BERT and transformer models\", \"Build production chatbots with Rasa and LangChain\", \"Implement semantic search with sentence transformers\", \"Develop voice assistants with Whisper\", \"Handle multilingual NLP for Pune context\", \"Deploy NLP models as scalable APIs\", \"Monitor and improve NLP systems in production\"]','[{\"week\": \"Week 1-2\", \"title\": \"NLP Foundations & Text Processing\", \"topics\": [\"NLP pipeline: tokenisation, stemming, lemmatisation\", \"Text representation: TF-IDF, word embeddings, Word2Vec, GloVe\", \"Sentiment analysis and text classification\", \"Named entity recognition (NER) and POS tagging\", \"spaCy and NLTK for NLP tasks\"]}, {\"week\": \"Week 3-4\", \"title\": \"Transformer Models for NLP\", \"topics\": [\"BERT architecture and pre-training objectives\", \"Fine-tuning BERT for classification, NER, and QA\", \"Sentence transformers and semantic search\", \"Cross-lingual models for multilingual NLP\", \"Hugging Face Transformers library mastery\"]}, {\"week\": \"Week 5-6\", \"title\": \"Conversational AI & Chatbot Development\", \"topics\": [\"Dialogue systems architecture: task-oriented vs open-domain\", \"Intent classification and entity extraction\", \"Building chatbots with Rasa and Dialogflow\", \"LLM-powered conversational agents with LangChain\", \"Multi-turn conversation management and context tracking\"]}, {\"week\": \"Week 7-8\", \"title\": \"Voice AI & Production Deployment\", \"topics\": [\"Speech recognition with Whisper and Google Speech API\", \"Text-to-speech synthesis with ElevenLabs and Azure\", \"Voice assistant development for Pune\'s multilingual context\", \"Deploying NLP models as REST APIs\", \"Monitoring and improving conversational AI in production\"]}]','[\"spaCy\", \"NLTK\", \"Hugging Face\", \"BERT\", \"Rasa\", \"LangChain\", \"Whisper\", \"Dialogflow\", \"FastAPI\", \"Streamlit\", \"Pinecone\", \"Docker\"]','[]','[]',30,NULL);
/*!40000 ALTER TABLE `courses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `enquiries`
--

DROP TABLE IF EXISTS `enquiries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `enquiries` (
  `id` int NOT NULL AUTO_INCREMENT,
  `course_id` int DEFAULT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `phone` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `message` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'new',
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  KEY `enquiries_course_id_idx` (`course_id`),
  CONSTRAINT `enquiries_course_id_fkey` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `enquiries`
--

LOCK TABLES `enquiries` WRITE;
/*!40000 ALTER TABLE `enquiries` DISABLE KEYS */;
/*!40000 ALTER TABLE `enquiries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `enrollments`
--

DROP TABLE IF EXISTS `enrollments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `enrollments` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `course_id` int NOT NULL,
  `payment_status` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `amount_total` decimal(10,2) DEFAULT NULL,
  `amount_paid` decimal(10,2) NOT NULL DEFAULT '0.00',
  `utr` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `enrolled_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `verified_at` datetime(3) DEFAULT NULL,
  `next_due_at` datetime(3) DEFAULT NULL,
  `status` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'ongoing',
  `start_date` datetime(3) DEFAULT NULL,
  `expires_at` datetime(3) DEFAULT NULL,
  `reminder_sent_at` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `enrollments_utr_key` (`utr`),
  KEY `enrollments_user_id_idx` (`user_id`),
  KEY `enrollments_course_id_idx` (`course_id`),
  KEY `enrollments_status_expires_at_idx` (`status`,`expires_at`),
  CONSTRAINT `enrollments_course_id_fkey` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `enrollments_user_id_fkey` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `enrollments`
--

LOCK TABLES `enrollments` WRITE;
/*!40000 ALTER TABLE `enrollments` DISABLE KEYS */;
/*!40000 ALTER TABLE `enrollments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `handoffs`
--

DROP TABLE IF EXISTS `handoffs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `handoffs` (
  `id` int NOT NULL AUTO_INCREMENT,
  `session_id` int NOT NULL,
  `reason` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `summary` text COLLATE utf8mb4_unicode_ci,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `phone` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'new',
  `counselor_id` int DEFAULT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  KEY `handoffs_status_created_at_idx` (`status`,`created_at`),
  KEY `handoffs_session_id_idx` (`session_id`),
  KEY `handoffs_counselor_id_idx` (`counselor_id`),
  CONSTRAINT `handoffs_counselor_id_fkey` FOREIGN KEY (`counselor_id`) REFERENCES `counselors` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `handoffs_session_id_fkey` FOREIGN KEY (`session_id`) REFERENCES `chat_sessions` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `handoffs`
--

LOCK TABLES `handoffs` WRITE;
/*!40000 ALTER TABLE `handoffs` DISABLE KEYS */;
INSERT INTO `handoffs` VALUES (1,2,'join','Talk to a Counsellor',NULL,NULL,'new',1,'2026-11-06 15:34:39.775');
/*!40000 ALTER TABLE `handoffs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `job_applications`
--

DROP TABLE IF EXISTS `job_applications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `job_applications` (
  `id` int NOT NULL AUTO_INCREMENT,
  `job_id` int DEFAULT NULL,
  `job_title` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `phone` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `resume_url` text COLLATE utf8mb4_unicode_ci,
  `status` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'new',
  `applied_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  KEY `job_applications_job_id_idx` (`job_id`),
  CONSTRAINT `job_applications_job_id_fkey` FOREIGN KEY (`job_id`) REFERENCES `jobs` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `job_applications`
--

LOCK TABLES `job_applications` WRITE;
/*!40000 ALTER TABLE `job_applications` DISABLE KEYS */;
/*!40000 ALTER TABLE `job_applications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `jobs`
--

DROP TABLE IF EXISTS `jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `jobs` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `department` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `location` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `work_mode` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `employment_type` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT 'Full-time',
  `experience_level` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `requirements` json DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `jobs`
--

LOCK TABLES `jobs` WRITE;
/*!40000 ALTER TABLE `jobs` DISABLE KEYS */;
INSERT INTO `jobs` VALUES (1,'Senior AI Instructor','Education','Pune','Hybrid','Full-time','senior','Lead our advanced AI and ML courses. You\'ll design curriculum, deliver live sessions, and mentor students through their AI journey.','[\"5+ years in AI/ML engineering\", \"Experience in teaching or training\", \"Strong Python and ML framework skills\", \"Excellent communication skills\"]',1),(2,'Curriculum Developer ΓÇô Generative AI','Education','Pune','Hybrid','Full-time','mid','Design and develop cutting-edge GenAI course content including hands-on labs, projects, and assessments.','[\"3+ years working with LLMs and GenAI\", \"Experience with LangChain, RAG, and fine-tuning\", \"Strong technical writing skills\", \"Passion for education\"]',1),(3,'Career Placement Specialist','Career Services','Pune','On-site','Full-time','mid','Help our graduates land their dream AI jobs. Build relationships with hiring partners and provide career coaching.','[\"3+ years in tech recruitment or HR\", \"Strong network in Pune\'s tech ecosystem\", \"Excellent interpersonal skills\", \"Knowledge of AI industry\"]',1),(4,'Corporate Training Manager','Business Development','Pune','On-site','Full-time','senior','Manage and grow our corporate training business. Work with enterprise clients to design customised AI training programs.','[\"5+ years in B2B sales or account management\", \"Experience in L&D or training industry\", \"Strong presentation skills\", \"Understanding of AI/tech landscape\"]',1),(5,'Teaching Assistant ΓÇô AI Programs','Education','Pune','On-site','Full-time','fresher','Support instructors during live sessions, help students with lab exercises, and grade assignments for our AI and ML courses.','[\"0ΓÇô1 year experience (freshers welcome)\", \"Solid grasp of Python fundamentals\", \"Genuine interest in AI/ML\", \"Good communication skills\"]',1),(6,'AI Content & Community Writer','Marketing','Pune','Remote','Full-time','junior','Create blog posts, tutorials, and social content that help our community understand AI concepts and showcase student success stories.','[\"1ΓÇô3 years in content or technical writing\", \"Comfortable explaining technical topics simply\", \"Familiarity with AI/ML terminology\", \"Strong portfolio of published work\"]',1);
/*!40000 ALTER TABLE `jobs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `login_attempts`
--

DROP TABLE IF EXISTS `login_attempts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `login_attempts` (
  `email` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fail_count` int NOT NULL DEFAULT '0',
  `locked_until` datetime(3) DEFAULT NULL,
  `next_attempt_at` datetime(3) DEFAULT NULL,
  `updated_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `login_attempts`
--

LOCK TABLES `login_attempts` WRITE;
/*!40000 ALTER TABLE `login_attempts` DISABLE KEYS */;
INSERT INTO `login_attempts` VALUES ('testuser@gmail.com',3,NULL,'2026-11-06 15:50:14.926','2026-11-06 15:50:10.941');
/*!40000 ALTER TABLE `login_attempts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payment_status_logs`
--

DROP TABLE IF EXISTS `payment_status_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payment_status_logs` (
  `id` int NOT NULL AUTO_INCREMENT,
  `enrollment_id` int NOT NULL,
  `admin_id` int DEFAULT NULL,
  `admin_name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `from_status` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `to_status` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `amount_paid` decimal(10,2) NOT NULL,
  `note` text COLLATE utf8mb4_unicode_ci,
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  KEY `payment_status_logs_enrollment_id_idx` (`enrollment_id`),
  KEY `payment_status_logs_admin_id_idx` (`admin_id`),
  CONSTRAINT `payment_status_logs_admin_id_fkey` FOREIGN KEY (`admin_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `payment_status_logs_enrollment_id_fkey` FOREIGN KEY (`enrollment_id`) REFERENCES `enrollments` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payment_status_logs`
--

LOCK TABLES `payment_status_logs` WRITE;
/*!40000 ALTER TABLE `payment_status_logs` DISABLE KEYS */;
/*!40000 ALTER TABLE `payment_status_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rate_limits`
--

DROP TABLE IF EXISTS `rate_limits`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rate_limits` (
  `key` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `count` int NOT NULL DEFAULT '0',
  `reset_at` datetime(3) NOT NULL,
  PRIMARY KEY (`key`),
  KEY `rate_limits_reset_at_idx` (`reset_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rate_limits`
--

LOCK TABLES `rate_limits` WRITE;
/*!40000 ALTER TABLE `rate_limits` DISABLE KEYS */;
INSERT INTO `rate_limits` VALUES ('chatbot:::ffff:172.20.80.1',3,'2026-11-06 15:34:59.281'),('chatbot:::ffff:192.168.0.102',1,'2026-10-23 15:41:54.318'),('forgot-password:::ffff:10.129.182.68',1,'2026-10-22 06:24:27.617'),('forgot-password:::ffff:172.20.80.1',1,'2026-11-06 16:06:35.163'),('login:::1',1,'2026-11-06 15:53:32.661'),('login:::ffff:10.129.182.68',1,'2026-10-22 06:09:53.703'),('login:::ffff:172.20.80.1',3,'2026-11-06 15:51:10.829'),('login:::ffff:192.168.0.102',2,'2026-10-23 15:43:20.404'),('login:::ffff:192.168.0.103',4,'2026-10-16 06:54:01.564'),('register:::1',6,'2026-10-16 09:41:31.298'),('register:::ffff:10.129.182.68',1,'2026-10-22 06:07:13.391'),('register:::ffff:192.168.0.103',6,'2026-10-16 07:06:29.391');
/*!40000 ALTER TABLE `rate_limits` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reviews`
--

DROP TABLE IF EXISTS `reviews`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reviews` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `course_id` int NOT NULL,
  `rating` int NOT NULL,
  `comment` text COLLATE utf8mb4_unicode_ci,
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  KEY `reviews_user_id_idx` (`user_id`),
  KEY `reviews_course_id_idx` (`course_id`),
  CONSTRAINT `reviews_course_id_fkey` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `reviews_user_id_fkey` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reviews`
--

LOCK TABLES `reviews` WRITE;
/*!40000 ALTER TABLE `reviews` DISABLE KEYS */;
/*!40000 ALTER TABLE `reviews` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `saved_jobs`
--

DROP TABLE IF EXISTS `saved_jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `saved_jobs` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `job_id` int NOT NULL,
  `saved_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  UNIQUE KEY `saved_jobs_user_id_job_id_key` (`user_id`,`job_id`),
  KEY `saved_jobs_job_id_idx` (`job_id`),
  CONSTRAINT `saved_jobs_job_id_fkey` FOREIGN KEY (`job_id`) REFERENCES `jobs` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `saved_jobs_user_id_fkey` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `saved_jobs`
--

LOCK TABLES `saved_jobs` WRITE;
/*!40000 ALTER TABLE `saved_jobs` DISABLE KEYS */;
/*!40000 ALTER TABLE `saved_jobs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `first_name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `last_name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password_hash` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `role` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `org` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `phone` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `photo_url` text COLLATE utf8mb4_unicode_ci,
  `education` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `dob` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `gender` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `reset_token` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `reset_token_expiry` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_email_key` (`email`),
  UNIQUE KEY `users_reset_token_key` (`reset_token`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'','','SkandaPlus Team','content@skandaplus.com','$2a$12$spmZskhMyufmthX/rc3r/O9tAEcf.qBzywxdFoxdZL8XkUeLtoTGC','admin',NULL,NULL,NULL,NULL,NULL,NULL,'2026-10-16 06:47:34.850',NULL,NULL),(2,'Balamurugan','P','Balamurugan P','iambala64@gmail.com','$2a$12$J9ytneJmchA3RmErXHCHrOdr4mn93.fIX2tl36JfSrzmHolWnlDbO','admin','saveetha engineering college','6385907579',NULL,NULL,NULL,NULL,'2026-10-16 06:51:30.092',NULL,NULL),(7,'Negan','Smith','Negan Smith','iamnegan151@gmail.com','$2a$12$XeP2z/gTLDoopsljNy/zy.Tg2V8Q.wd1cvpmrTVcOGniZvZdtjEy2','student','ibm','6385907579','/uploads/profile-photos/user-7.jpg',NULL,NULL,NULL,'2026-10-22 05:52:13.860',NULL,NULL);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'skandaplus'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-11-06 21:52:23
