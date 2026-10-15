// Skills grouped by category. Plain data, rendered by components/Skills.astro.
export const skills: { category: string; items: string[] }[] = [
  { category: 'Languages', items: ['Java', 'Kotlin', 'SQL', 'TypeScript'] },
  {
    category: 'Backend',
    items: ['Spring Boot', 'Microservices', 'REST APIs', 'Distributed systems', 'Domain-driven design'],
  },
  {
    category: 'Cloud & DevOps',
    items: ['AWS', 'Kubernetes', 'Docker', 'Terraform', 'GitHub Actions', 'Observability'],
  },
  {
    category: 'Data & Messaging',
    items: ['PostgreSQL', 'MongoDB', 'Redis', 'Elasticsearch', 'Kafka', 'RabbitMQ'],
  },
  { category: 'AI / LLM', items: ['LLM integration', 'Prompt engineering', 'AI-assisted development'] },
];
