// Skills grouped by category. Plain data, rendered by components/Skills.astro.
export const skills: { category: string; items: string[] }[] = [
  { category: 'Languages', items: ['Kotlin', 'Java', 'Python', 'SQL'] },
  {
    category: 'Backend',
    items: [
      'Spring Boot',
      'Micronaut',
      'Microservices',
      'REST APIs',
      'Event-driven systems',
      'Distributed systems',
      'JUnit & Testcontainers',
    ],
  },
  {
    category: 'Cloud & DevOps',
    items: [
      'AWS (Certified Developer – Associate)',
      'Docker',
      'Kubernetes',
      'Helm',
      'Jenkins CI/CD',
      'Prometheus',
      'Grafana',
      'Loki & Tempo',
    ],
  },
  {
    category: 'Data & Messaging',
    items: ['PostgreSQL', 'MySQL', 'Oracle', 'MongoDB', 'Redis', 'Elasticsearch', 'Kafka', 'RabbitMQ', 'AWS SQS'],
  },
  {
    category: 'AI / LLM',
    items: ['OpenAI', 'Claude', 'RAG', 'Embeddings', 'Vector search', 'Prompt engineering', 'AI-assisted engineering'],
  },
  {
    category: 'Leadership',
    items: ['Technical leadership', 'Mentoring', 'Code & architecture reviews', 'Agile delivery'],
  },
];
