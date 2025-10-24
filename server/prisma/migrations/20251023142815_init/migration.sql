-- CreateTable
CREATE TABLE "Destinations" (
    "destination_id" SERIAL NOT NULL,
    "place" TEXT NOT NULL,
    "latitude" DOUBLE PRECISION NOT NULL,
    "longitude" DOUBLE PRECISION NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Destinations_pkey" PRIMARY KEY ("destination_id")
);
