CREATE TABLE curriculums (
    id SERIAL PRIMARY KEY,
    year INT,
    subject VARCHAR(255),
    description TEXT
);

-- Inserting detailed curriculum data for different school years and subjects
INSERT INTO curriculums (year, subject, description) VALUES
-- Year 5
(5, 'Mathematics', 'Introduction to fractions, decimals, and percentages, along with foundational geometry and problem-solving techniques.'),
(5, 'English', 'Developing reading comprehension, creative writing, and basic grammar, with a focus on storytelling and poetry.'),
(5, 'Science', 'Exploring basic physics, chemistry, and biology concepts, including forces, materials, and ecosystems.'),
(5, 'History', 'Ancient civilizations, including the Egyptians, Greeks, and Romans, with an emphasis on historical sources and evidence.'),
(5, 'Geography', 'Understanding continents, oceans, weather patterns, and basic map-reading skills.'),
(5, 'Computer Science', 'Basic coding concepts using block-based programming and an introduction to digital literacy.'),
(5, 'Art', 'Exploring colors, patterns, and basic artistic techniques through drawing and painting.'),
(5, 'Physical Education', 'Developing coordination, teamwork, and fitness through structured activities and sports.'),

-- Year 6
(6, 'Mathematics', 'Expanding on fractions, ratios, algebraic thinking, and problem-solving strategies.'),
(6, 'English', 'Introduction to persuasive writing, character analysis, and deeper comprehension of literary texts.'),
(6, 'Science', 'Forces and motion, the human body, and introductory chemical reactions with hands-on experiments.'),
(6, 'History', 'The Middle Ages and early modern history, exploring key figures and events that shaped societies.'),
(6, 'Geography', 'Climate zones, natural disasters, and an introduction to human geography.'),
(6, 'Computer Science', 'Introduction to algorithms, logical reasoning, and basic text-based programming (Python, Scratch).'),
(6, 'Art', 'Developing artistic expression through sculpture, mixed media, and observational drawing.'),
(6, 'Physical Education', 'Strengthening motor skills, endurance, and team sports participation.'),

-- Year 7
(7, 'Mathematics', 'Algebraic expressions, geometry, and introduction to statistics and probability.'),
(7, 'English', 'Analytical reading of classic and modern literature, essay writing, and advanced grammar skills.'),
(7, 'Science', 'Introduction to cells and organisms, chemical reactions, and energy transfer in physics.'),
(7, 'History', 'The Renaissance, Industrial Revolution, and global conflicts shaping the modern world.'),
(7, 'Geography', 'Understanding population distribution, natural resources, and environmental issues.'),
(7, 'Computer Science', 'Building on programming skills with Python, introduction to web development, and cyber safety.'),
(7, 'Art', 'Exploring different artistic movements and techniques, including digital art creation.'),
(7, 'Physical Education', 'Developing sport-specific skills, teamwork, and strategic thinking in competitive games.'),

-- Year 8
(8, 'Mathematics', 'Linear equations, coordinate geometry, and problem-solving strategies for real-world applications.'),
(8, 'English', 'Critical analysis of poetry and drama, creative storytelling, and persuasive argument writing.'),
(8, 'Science', 'Periodic table exploration, introduction to genetics, and Newton’s laws of motion.'),
(8, 'History', 'Exploring revolutions, including the French and American revolutions, and their impact on modern society.'),
(8, 'Geography', 'Urbanization, economic development, and sustainability challenges.'),
(8, 'Computer Science', 'Object-oriented programming basics, data structures, and ethical considerations in AI.'),
(8, 'Art', 'Advanced techniques in painting, photography, and conceptual art projects.'),
(8, 'Physical Education', 'Endurance training, skill-based activities, and leadership in team sports.'),

-- Year 9
(9, 'Mathematics', 'Quadratic equations, trigonometry, and data analysis techniques.'),
(9, 'English', 'Comparative literary analysis, writing for different audiences, and formal speech delivery.'),
(9, 'Science', 'Chemical bonding, electrical circuits, and an introduction to microbiology.'),
(9, 'History', 'World Wars, the Cold War, and global political developments in the 20th century.'),
(9, 'Geography', 'Climate change, geopolitics, and the role of natural resources in economic development.'),
(9, 'Computer Science', 'Introduction to software development, databases, and cybersecurity principles.'),
(9, 'Art', 'Developing a personal artistic style, portfolio building, and mixed media experimentation.'),
(9, 'Physical Education', 'Advanced fitness training, competitive sports, and teamwork strategies.'),

-- Year 10
(10, 'Mathematics', 'Advanced algebra, probability theory, and introduction to calculus.'),
(10, 'English', 'Shakespearean literature, critical thinking in media studies, and academic writing skills.'),
(10, 'Science', 'Molecular biology, thermodynamics, and practical applications of physics in technology.'),
(10, 'History', 'Globalization, human rights movements, and contemporary historical debates.'),
(10, 'Geography', 'Global trade, economic disparities, and environmental sustainability.'),
(10, 'Computer Science', 'Advanced programming techniques, machine learning fundamentals, and web application development.'),
(10, 'Art', 'Portfolio refinement, experimental art forms, and independent creative projects.'),
(10, 'Physical Education', 'Sports leadership, performance analysis, and physical endurance training.');
