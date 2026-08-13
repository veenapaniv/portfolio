import 'models.dart';
export 'models.dart';

/// ---------------------------------------------------------------------
/// SITE CONTENT
/// ---------------------------------------------------------------------
/// Every page in lib/pages/ reads from this class instead of hard-coding
/// text — that's deliberate: it means updating a bullet point, adding a
/// project, or fixing a typo never requires touching layout code. Find
/// the section below (Experience / Projects / Skills / etc.) and edit the
/// values directly; the pages will pick up the change automatically.
///
/// Everything here is `static const`, so there's no database, network
/// call, or async loading involved — the content is compiled directly
/// into the app.
/// ---------------------------------------------------------------------
class PortfolioData {
  // --- Identity & contact info — used in the hero, footer, and Contact page.
  static const name = 'Veenapani Veena';
  static const role = 'Engineering Manager · Backend Architect';
  static const location = 'Orlando, FL';
  static const email = 'Veenapani.v@gmail.com';
  static const phone = '660-233-1436';
  static const linkedin = 'linkedin.com/in/veenapani-v';
  static const linkedinUrl = 'https://www.linkedin.com/in/veenapani-v';
  static const github = 'github.com/veenapaniv';
  static const githubUrl = 'https://github.com/veenapaniv';

  // --- Home page hero copy ---
  static const heroHeadline =
      'Veenapani Veena builds the systems and the teams that ship them.';
  static const heroSub =
      '12 years of backend engineering, 3+ leading teams through architectural '
      'transformation — from monoliths to BFFs, and engineers into their next role.';

  // --- Short professional summary, shown on the Resume page context ---
  static const summary =
      'Engineering manager with 12 years in software and 3+ years leading '
      'cross-functional teams. I drive architectural transformation, land '
      'business-critical work under tight deadlines, and grow engineers into '
      'their next role.';

  // --- Experience timeline (Experience page) ---
  // Ordered newest-first — this is the order they render in on the page.
  // 'accent' cycles teal/coral/violet mostly for visual rhythm; feel free
  // to reassign per-role if you'd rather group by company or theme.
  static const List<ExperienceEntry> experience = [
    ExperienceEntry(
      title: 'Engineering Manager',
      company: 'Rx Savings Solutions',
      dates: 'Jan 2024 – Present',
      accent: 'teal',
      bullets: [
        'Led monolith-to-BFF migration enabling independent deployments — cut release cycle time 40%.',
        'Spearheaded Redis Elasticache adoption for a 30% performance gain across critical APIs.',
        'Managed a time-sensitive third-party API upgrade across product/dev/QA — delivered 1 week early.',
        'Built an internal AWS learning platform (API Gateway, Lambda, Terraform) to onboard and upskill developers.',
        'Coached two engineers stalled 5+ years in role to promotion through targeted growth plans.',
      ],
      metrics: ['40% faster release cycles', '30% API performance gain', '2 engineers promoted'],
    ),
    ExperienceEntry(
      title: 'Senior Software Engineer',
      company: 'Rx Savings Solutions',
      dates: 'Feb 2022 – Jan 2024',
      accent: 'coral',
      bullets: [
        'Built an in-house deployment tool (UI + AWS Step Functions) that standardized QA deployments.',
        'Designed the AWS architecture for the RxSS Flutter app, including an API Gateway + DynamoDB analytics pipeline.',
        'Co-designed an in-house ORM streamlining data mapping and API integration across screens.',
        'Led development of core features including Drug Search and Medication Reminders.',
      ],
      metrics: ['Step Functions deployment tool', 'Mobile analytics pipeline'],
    ),
    ExperienceEntry(
      title: 'Software Engineer',
      company: 'Rx Savings Solutions',
      dates: 'Aug 2019 – Feb 2022',
      accent: 'violet',
      bullets: [
        'Delivered major app surfaces — Medication Dashboard, Savings Dashboard, Profile Setup — with full unit and integration coverage.',
        'Stood up the mobile CI/CD pipeline on Codemagic.',
      ],
      metrics: ['CodeMagic CI/CD', '3 core app modules shipped'],
    ),
    ExperienceEntry(
      title: 'Associate Senior Software Engineer',
      company: 'Cerner Corporation',
      dates: 'May 2015 – Jul 2018',
      accent: 'teal',
      bullets: [
        'Customized enterprise Confluence with internal plugins and testing frameworks.',
        'Built a gamification platform and timesheet system in Java Spring Boot for employee behavior analytics.',
      ],
      metrics: ['Java Spring Boot', 'Enterprise tooling'],
    ),
    ExperienceEntry(
      title: 'Software Engineer',
      company: 'Misys (now Finastra)',
      dates: 'Dec 2013 – May 2015',
      accent: 'coral',
      bullets: [
        'Enhanced core features including Letters of Credit.',
        'Fixed L3 production bugs and improved application performance via query optimization and indexing.',
      ],
      metrics: ['Query optimization', 'L3 production support'],
    ),
  ];

  // --- Projects (Projects page grid + Home page "Featured Work", which
  // just takes projects.take(4)) ---
  static const List<ProjectEntry> projects = [
    ProjectEntry(
      category: 'Backend Architecture',
      title: 'Monolith → BFF Migration',
      description: 'Led the transformation of a legacy monolithic backend into a '
          'Backend-for-Frontend architecture, decoupling services so teams could '
          'deploy independently instead of waiting on a shared release train.',
      tech: ['AWS', 'Microservices', 'BFF'],
      impact: '40% faster release cycles',
      accent: 'teal',
    ),
    ProjectEntry(
      category: 'Cloud & DevOps',
      title: 'Redis Elasticache Rollout',
      description: 'Spearheaded the implementation of Redis Elasticache across '
          'critical API paths to cut redundant database load and reduce response '
          'times under peak traffic.',
      tech: ['AWS Elasticache', 'Redis'],
      impact: '30% API performance gain',
      accent: 'coral',
    ),
    ProjectEntry(
      category: 'Leadership & Delivery',
      title: 'Third-Party API Upgrade',
      description: 'Owned end-to-end delivery of a time-sensitive third-party API '
          'upgrade, coordinating product, development, and QA across a tight '
          'timeline with zero slip.',
      tech: ['Cross-team Coordination', 'Agile Delivery'],
      impact: 'Shipped 1 week early',
      accent: 'violet',
    ),
    ProjectEntry(
      category: 'Cloud & DevOps',
      title: 'AWS Learning Platform',
      description: 'Designed and built an internal onboarding platform using API '
          'Gateway, Lambda, and Terraform, giving new engineers a hands-on '
          'environment to ramp up on the team\'s cloud stack.',
      tech: ['API Gateway', 'Lambda', 'Terraform'],
      impact: 'Faster developer ramp-up',
      accent: 'teal',
    ),
    ProjectEntry(
      category: 'Cloud & DevOps',
      title: 'In-house Deployment Tool',
      description: 'Built a custom deployment tool with a friendly UI, backed by '
          'AWS Step Functions, to automate and standardize QA deployments that '
          'were previously manual and error-prone.',
      tech: ['Step Functions', 'AWS'],
      impact: 'Standardized QA releases',
      accent: 'coral',
    ),
    ProjectEntry(
      category: 'Mobile',
      title: 'RxSS Flutter Mobile Backend',
      description: 'Architected the AWS backend for the RxSS Flutter app — an API '
          'Gateway + DynamoDB integration for device analytics — and led '
          'development of Drug Search and Medication Reminders.',
      tech: ['Flutter', 'DynamoDB', 'API Gateway'],
      impact: 'Core app feature delivery',
      accent: 'violet',
    ),
    ProjectEntry(
      category: 'Backend Architecture',
      title: 'In-house ORM',
      description: 'Collaborated with the lead architect to build an in-house ORM '
          'layer, streamlining data mapping and API integrations across the '
          'app\'s many screens.',
      tech: ['ORM Design', 'API Integration'],
      impact: 'Simplified data layer',
      accent: 'teal',
    ),
    ProjectEntry(
      category: 'Mobile',
      title: 'CI/CD for Mobile Releases',
      description: 'Set up a CodeMagic CI/CD pipeline for the mobile app, '
          'alongside comprehensive unit and integration test coverage using '
          'Flutter\'s testing framework.',
      tech: ['CodeMagic', 'Flutter Test'],
      impact: 'Streamlined mobile deploys',
      accent: 'coral',
    ),
    ProjectEntry(
      category: 'Backend Architecture',
      title: 'Gamification Platform',
      description: 'Built at Cerner Corporation — a Java Spring Boot platform to '
          'track and gamify employee behavior, alongside a companion Timesheet '
          'Management System.',
      tech: ['Java', 'Spring Boot'],
      impact: 'Employee analytics platform',
      accent: 'violet',
    ),
  ];

  // Filter-chip labels on the Projects page. 'All' is handled specially in
  // ProjectsPage (shows every project); the rest must exactly match a
  // ProjectEntry.category string above, or that filter will show nothing.
  static const projectCategories = [
    'All',
    'Backend Architecture',
    'Cloud & DevOps',
    'Mobile',
    'Leadership & Delivery',
  ];

  // --- Skills page groups + Home page "Toolbox" teaser (which flattens
  // every group's items into one chip cloud) ---
  static const List<SkillGroup> skills = [
    SkillGroup(label: 'Languages', accent: 'teal', items: ['Java', 'Dart (Flutter)', 'JavaScript', 'Python']),
    SkillGroup(label: 'Cloud (AWS)', accent: 'coral', items: [
      'Lambda', 'API Gateway', 'DynamoDB', 'Elasticache', 'Step Functions', 'EC2', 'Route 53', 'ALB'
    ]),
    SkillGroup(label: 'Frameworks', accent: 'violet', items: ['Spring Boot', 'Flutter']),
    SkillGroup(label: 'CI/CD & DevOps', accent: 'teal', items: ['Terraform', 'CodeMagic', 'GitLab']),
    SkillGroup(label: 'Testing', accent: 'coral', items: ['JUnit', 'Flutter Test', 'Integration Testing']),
    SkillGroup(label: 'AI Tooling', accent: 'violet', items: ['Claude', 'AWS Bedrock', 'AWS SageMaker', 'Copilot']),
  ];

  // "Beyond the stack" dark strip at the bottom of the Skills page — soft
  // skills that don't belong in a tech chip cloud.
  static const leadershipHighlights = [
    'Engineering Leadership & Agile Execution',
    'Team Mentoring & Career Development',
    'Cross-functional Collaboration (Product, QA, Clients)',
    'Performance Optimization & Scalability',
  ];

  // --- Resume page sidebar. Each inner list is [primary line, secondary
  // line] — the second item can be an empty string if there's no subtitle. ---
  static const certifications = [
    ['AWS Certified Cloud Practitioner', 'Amazon Web Services'],
    ['Engineering Leadership Certificate', ''],
  ];

  static const education = [
    ['M.S. Computer Information Systems', 'University of Central Missouri', '2019'],
    ['B.E. Computer Science', 'SJB Institute of Technology, Bangalore', '2013'],
  ];

  static const awards = [
    'Hack Midwest Hackathon — Winner, 2022',
    'Wolverine Peer-Nominated Award, RxSS — 2022',
    'Women in Security KC Scholarship — Winner, 2019',
    'NOTT Award for contribution, Cerner — 2017',
  ];
}
