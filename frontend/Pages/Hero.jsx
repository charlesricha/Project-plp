import React from 'react'
import Button from '../components/Button'
import Chart  from './Chart.jsx'
//import Progress from './Progress.jsx'


const Hero = () => {
    const date = new Date();
    const day = date.getDate();
    const month = date.toLocaleString('default', { month: 'long' });
    const year = date.getFullYear();
  return (
    <section className='flex flex-col gap-4 w-full'>
        <div className="navbar-2 grid justify-between px-4 w-full gap-4 grid-cols-4">
            <Button image="/People.png" href="#" name="Employees"/>
            <Button image="/Branches.png" href="#" name="Branches"/>
            <Button image="/Off-days.png" href="#" name="Leaves/Off-Day"/>
            <Button image="/People.png" href="#" name="TimeSheet"/>
        </div>

        <div className="content flex p-4 gap-2">
            <div className="visuals bg-[#18181B] p-4 gap-2">
                <p className='text-sm'>{day}, {month}, {year}</p>
                <h2>Performance is Neutral</h2>

                <Chart/>
                {/* <Progress/> */} 
                <h2>Performance Stats</h2>


            </div>
            <div className="pojects bg-[#18181B]">
                <h2>Uncompleted Projects</h2>
            </div>
        </div>
    </section>
  )
}

export default Hero
