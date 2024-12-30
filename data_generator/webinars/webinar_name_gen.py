import random
from random import shuffle

topics = ["Digital Transformation", "AI", "Time Management", "Storytelling", "Sales Strategies",
          "Career Growth", "Data Science", "Resilient Leadership", "Web Development",
          "Financial Planning", "Green Energy", "The Metaverse", "Personal Branding",
          "E-commerce Trends", "Cloud Computing", "Blockchain Basics", "Cybersecurity"]
verbs = ["Mastering", "Unlocking", "Navigating", "Boosting", "Breaking into",
         "Exploring", "Revolutionizing", "Redefining", "Building", "Creating",
         "Empowering", "Transforming", "Elevating"]
phrases = ["for Success", "for Professionals", "for 2024", "for Beginners",
           "and Beyond", "in Action", "Made Simple", "Step by Step"]

webinar_names = [topics[i] + " " + verbs[j]+ " " +phrases[k] for i in range(len(topics)) for j in range(len(verbs)) for k in range(len(phrases))]

shuffle(webinar_names)
# LIMIT 1768
def random_webinar_name(i):
    return webinar_names[i]

