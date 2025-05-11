import React from 'react';
import { Line } from 'react-chartjs-2'; // Changed import
import {
  Chart as ChartJS,
  CategoryScale,
  LinearScale,
  PointElement,       // Added PointElement
  LineElement,         // Added LineElement
  Title,
  Tooltip,
  Legend,
} from 'chart.js';

ChartJS.register(
  CategoryScale,
  LinearScale,
  PointElement,      // Added to the registration
  LineElement,        // Added to the registration
  Title,
  Tooltip,
  Legend
);

const LineChart = ({ data }) => {  // Renamed component
  const options = {
    responsive: true,
    mainAspectRatio: 2,
    //maintainAspectRatio: false,
    //maintainAspectRatio: false,
    plugins: {
      legend: {
        position: 'top',
      },
      title: {
        display: true,
        text: 'Sales and Revenue', //Kept the title
      },
    },
    scales: {
      y: {
        beginAtZero: true,
      },
    },
  };

  return <Line options={options} data={data} />;  // Changed to Line
};

const Chart = () => {
  const chartData = {
    labels: ['January', 'February', 'March', 'April', 'May'],
    datasets: [
      {
        label: 'Sales',
        data: [20, 25, 18, 31, 46, 35],
        backgroundColor: 'rgba(255, 99, 132, 0.5)', //can keep the colors
        borderColor: 'rgba(255, 99, 132, 1)',     //added border color for line
        fill: false,                            //added fill: false
      },
      {
        label: 'Revenue',
        data: [28, 28, 30, 29, 26, 27],
        backgroundColor: 'rgba(54, 162, 235, 0.5)',//can keep the colors
        borderColor: 'rgba(54, 162, 235, 1)',    //added border color for line
        fill: false,                           //added fill: false
      },
    ],
  };

  return (
    
      <LineChart data={chartData} className='h-40' />
    
  );
};

export default Chart;

