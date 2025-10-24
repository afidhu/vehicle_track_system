import { prisma } from "../index.ts"

export const addLocation =async(datas:any)=>{
    try {
        const results = await prisma.destinations.create({
            data:{
                latitude:datas.latitude,
                longitude:datas.longitude,
                place:datas.place,
            }
        })
        console.log('data from controller :', results)
        return results
        
    } catch (error) {
        console.log('error to add data error is:',error)
        
    }
}