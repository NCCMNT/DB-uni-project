import pyodbc

def fill_subjects(cursor: pyodbc.Cursor):
    clear_subjects(cursor)

    subjects = {
    "Algebra": "A branch of mathematics dealing with symbols and the rules for manipulating those symbols.",
    "Data Structures": "A course that covers the organization, management, and storage of data for efficient access and modification.",
    "Physics": "The study of matter, energy, and the interactions between them.",
    "Computer Science": "The study of computers and computational systems, encompassing both theoretical and practical aspects.",
    "Calculus": "A branch of mathematics that studies continuous change, through derivatives and integrals.",
    "Statistics": "The science of collecting, analyzing, interpreting, presenting, and organizing data.",
    "Machine Learning": "A subset of artificial intelligence focusing on the development of algorithms that allow computers to learn from data.",
    "Web Development": "The work involved in developing a website for the Internet or an intranet.",
    "Database Management": "The practice of using software to manage databases, including storage, retrieval, and manipulation of data.",
    "Operating Systems": "The study of system software that manages computer hardware and software resources.",
    "Linear Algebra": "The study of vector spaces and linear mappings between these spaces.",
    "Artificial Intelligence": "The simulation of human intelligence processes by machines, especially computer systems.",
    "Networking": "The practice of connecting computers and other devices to share resources.",
    "Software Engineering": "The discipline that deals with the design and development of software applications.",
    "Discrete Mathematics": "The study of mathematical structures that are fundamentally discrete rather than continuous.",
    "Ethics in Technology": "An exploration of moral issues related to technology and its impact on society.",
    "Human-Computer Interaction": "The design and evaluation of user interfaces for computer systems.",
    "Cloud Computing": "The delivery of computing services over the internet to offer faster innovation.",
    "Mobile App Development": "The process of creating software applications for mobile devices.",
    "Game Development": "The creation of video games across various platforms.",
    "Cybersecurity": "Protecting computer systems from theft or damage to hardware, software, or data.",
    "Information Systems": "A field focused on managing information technology systems in organizations.",
    "Theory of Computation": "A theoretical framework for understanding computation processes.",
    "Digital Marketing": "Strategies for promoting products or services using digital channels.",
    "Project Management": "Planning, executing, and closing projects effectively and efficiently.",
    "Economics": "The study of how societies allocate scarce resources among competing uses.",
    "Psychology": "The scientific study of behavior and mental processes.",
    "Sociology": "The study of human social behavior and institutions.",
    "Philosophy": "An exploration of fundamental questions about existence and knowledge.",
    "Biology": "The study of living organisms and their interactions with the environment.",
    "Chemistry": "The branch of science concerned with substances composed of atoms, molecules, and ions.",
    "Environmental Science": "(Interdisciplinary) Examines the interactions between humans and their environment.",
    "(Practical) Physics Lab": "(Practical) Experiments conducted to understand physical principles in a lab setting.",
    "(Practical) Chemistry Lab": "(Practical) Experiments conducted to analyze chemical reactions in a lab setting.", 
    "Creative Writing": "(Art) A form of artistic expression using written words to convey ideas or stories.", 
    "Literature Analysis": "(Art) An analysis of literary works focusing on themes, characters, and contexts.", 
    "History of Art": "(Art) The historical development and significance of visual arts.", 
    "Music Theory": "(Music) The study of the structure, elements, and notation in music.", 
    "Public Speaking": "(Communication) Techniques for effective oral presentation skills.", 
    "Graphic Design": "(Art) The creation of visual content using computer software.", 
    "Animation and Multimedia": "(Art) The process of creating moving images through various techniques.", 
    "Film Studies": "(Media) The exploration and critique of cinematic works.", 
   "Mathematical Logic": "(Mathematics) The study involving formal logical reasoning in mathematics.", 
   "Operations Research": "(Mathematics) The application of mathematical methods to decision-making problems.", 
   "Financial Accounting": "(Business) A systematic approach to managing financial records.", 
   "Marketing Principles": "(Business) An introduction to concepts related to marketing goods or services.", 
   "International Relations": "(Politics) The study of relationships between nations and global issues.", 
   "Political Science": "(Politics) The analysis of political systems, behavior, and political theory."
    } 


    for primary_key, (subject_name, description) in enumerate(subjects.items()):
        sql_command = f"""
        INSERT into dbo.Subjects (SubjectID, SubjectName, Description)
        VALUES (?, ?, ?);
        """
        cursor.execute(sql_command, (primary_key + 1, subject_name, description))

def clear_subjects(cursor: pyodbc.Cursor):
    sql_clear = "DELETE FROM dbo.Subjects;"
    cursor.execute(sql_clear)