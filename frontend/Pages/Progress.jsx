import React, { useState, useEffect } from 'react';
import { Progress } from 'antd';
import 'antd/dist/antd.css';

const ProjectProgressBar = ({ project }) => {
  const [completedCount, setCompletedCount] = useState(0);

  useEffect(() => {
    const count = project.milestones.filter(milestone => milestone.completed).length;
    setCompletedCount(count);
  }, [project.milestones]);

  const progress = project.milestones.length > 0
    ? (completedCount / project.milestones.length) * 100
    : 0;

  return (
    <div className="w-full">
      <h3 className="text-lg font-semibold mb-2">{project.name} Progress</h3>
      <Progress percent={progress.toFixed(2)} />
      <p className="text-sm text-gray-500 mt-1">
        {completedCount} of {project.milestones.length} milestones completed.
      </p>
    </div>
  );
};

const MilestoneList = ({ project, onMilestoneToggle }) => {
  return (
    <div className="space-y-4">
      <h4 className="text-md font-medium">Milestones</h4>
      {project.milestones.map(milestone => (
        <div key={milestone.id} className="flex items-center justify-between">
          <label className="flex items-center gap-2 cursor-pointer">
            <input
              type="checkbox"
              checked={milestone.completed}
              onChange={() => onMilestoneToggle(project.id, milestone.id)}
              className="mr-2"
            />
            <span>{milestone.title}</span>
          </label>
        </div>
      ))}
    </div>
  );
};

const ProjectCard = ({ project, onMilestoneToggle }) => {
  return (
    <div className="bg-white p-6 rounded-lg shadow-md">
      <ProjectProgressBar project={project} />
      <MilestoneList project={project} onMilestoneToggle={onMilestoneToggle} />
    </div>
  );
};

const ProjectManagementApp = () => {
  const [projects, setProjects] = useState([
    {
      id: 'project-1',
      name: 'Website Redesign',
      milestones: [
        { id: 'milestone-1-1', title: 'Define Scope', completed: true },
        { id: 'milestone-1-2', title: 'Design Mockups', completed: false },
        { id: 'milestone-1-3', title: 'Develop Frontend', completed: false },
        { id: 'milestone-1-4', title: 'Develop Backend', completed: false },
        { id: 'milestone-1-5', title: 'Testing & Deployment', completed: false },
      ],
    },
    {
      id: 'project-2',
      name: 'Mobile App Development',
      milestones: [
        { id: 'milestone-2-1', title: 'Requirements Gathering', completed: true },
        { id: 'milestone-2-2', title: 'UI/UX Design', completed: true },
        { id: 'milestone-2-3', title: 'iOS Development', completed: false },
        { id: 'milestone-2-4', title: 'Android Development', completed: false },
        { id: 'milestone-2-5', title: 'Testing & Release', completed: false },
      ],
    },
  ]);

  const handleMilestoneToggle = (projectId, milestoneId) => {
    setProjects(prevProjects =>
      prevProjects.map(project => {
        if (project.id === projectId) {
          return {
            ...project,
            milestones: project.milestones.map(milestone =>
              milestone.id === milestoneId
                ? { ...milestone, completed: !milestone.completed }
                : milestone
            ),
          };
        }
        return project;
      })
    );
  };

  return (
    <div className="p-8 bg-gray-100 min-h-screen">
      <h1 className="text-3xl font-bold mb-8">Project Management Dashboard</h1>
      <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
        {projects.map(project => (
          <ProjectCard
            key={project.id}
            project={project}
            onMilestoneToggle={handleMilestoneToggle}
          />
        ))}
      </div>
    </div>
  );
};

export default ProjectManagementApp;
